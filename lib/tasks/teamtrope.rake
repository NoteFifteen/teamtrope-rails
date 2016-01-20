namespace :teamtrope do

  desc "Populates ProjectGridTableRow"
  task populate_pgtr: :environment do

    # loading the roles into a hash table where the symbolized role name is the
    # key and the id is the value
    roles = Hash[*Role.all.map{ | role | [role.name.downcase.gsub(/ /, "_").to_sym, role.id] }.flatten]

    Project.find_each do | project |

      pgtr = project.project_grid_table_row
      pgtr ||= project.build_project_grid_table_row

      # adding each role
      roles.each do | key, value |
        next if %w( advisor agent ).include?(key.to_s)
        pgtr[key] = project.team_memberships.includes(:member).where(role_id: value).map(&:member).map(&:name).join(", ")
      end
      # adding the genres
      pgtr.genre = project.genres.map(&:name).join(", ")

      # adding the current_tasks
      project.current_tasks.includes(:task => :workflow).each do | ct |
        pgtr[ct.task.workflow.name.downcase.gsub(/ /, "_") + "_task_id"] = ct.task.id
        pgtr[ct.task.workflow.name.downcase.gsub(/ /, "_") + "_task_name"] = ct.task.name
        pgtr[ct.task.workflow.name.downcase.gsub(/ /, "_") + "_task_display_name"] = ct.task.display_name
        pgtr[ct.task.workflow.name.downcase.gsub(/ /, "_") + "_task_last_update"] = ct.updated_at
      end

      # adding the teamroom_link
      pgtr.teamroom_link = project.teamroom_link

      # adding the title
      pgtr.title = project.book_title

      # adding the imprint
      pgtr.imprint = project.imprint.name unless project.imprint.nil?

      #saving the entry
      pgtr.save
    end
  end

  desc "Updates the Cover Preview where one may not already exist"
  task update_cover_previews: :environment do
    CoverTemplate.where('ebook_front_cover_file_name IS NOT NULL AND cover_preview_file_name IS NULL').each do |cover_template|
      cover_template.cover_preview = cover_template.ebook_front_cover
      cover_template.save
    end
  end

  # Consider building a hash that links the column name to the csv field name and
  # an array of hash keys for each view that way we don't have magic numbers.
  # Rendering a different view would be as simple as looping through the array,
  # using the key at each index and fetching the data out of the hash with it.
  desc "Generates the Master Metadata Spreadsheet"
  task generate_master_metadata_spreadsheet: :environment do
    require 'csv'

    # building the header
    header = "Project ID,Title,Series Name,Series Number,\"Author (Last,First)\",\"Author (First,Last)\",PFS Author Name,Other Contributors,Team and Pct,Imprint,Print ISBN,epub ISBN,Format,Publication Date,Month,Year,Page Count,Print Price,Ebook Price(Will vary based on promos and price chagnes),Library Price,BISAC, BISAC Description,BISAC2, BISAC Description 2,BISAC3, BISAC Description 3,Search Terms,Summary,Author Bio,Squib"

    csv_header = ["Project ID","Title","Series Name","Series Number","Author (Last,First)","Author (First,Last)","PFS Author Name","Other Contributors","Team and Pct","Imprint","ASIN","Print ISBN","epub ISBN","Format","Publication Date","Month","Year","Page Count","Print Price","Ebook Price(Will vary based on promos and price changes)","Library Price","BISAC", "BISAC Description","BISAC2", "BISAC Description 2","BISAC3", "BISAC Description 3","Search Terms","Summary","Author Bio","Squib"]

    # set the row size which is equal to our header row split on the
    row_size = header.gsub(/\".*?,.*?\"/,'').split(',').count


    csv_string = CSV.generate do |csv|

      puts header
      csv << csv_header


      # fetch all projects that are production complete which indicates that they have been published.
      project_grid_table_rows = ProjectGridTableRow.published_books

      project_grid_table_rows.each do | pgtr |

        row = Array.new(row_size)

        project = pgtr.project

        row[0] = project.id
        row[1] = project.book_title

        unless project.publication_fact_sheet.nil?
          row[2] = project.publication_fact_sheet.series_name
          row[3] = project.publication_fact_sheet.series_number
        end

        # if there are are two authors most likely the main author was the one added first
        # project.authors returns a TeamMembership::ActiveRecord_AssociationRelation so we
        # cannot call order_by but we can use sort.　(what's faster to_a or map? )
        authors = project.authors.to_a.sort{ | a, b | a.created_at <=> b.created_at }

        first_author = authors.slice!(0)

        row[4] = first_author.last_name_first
        row[5] = first_author.member.name

        row[6] = project.publication_fact_sheet.author_name

        # row[6] = "\"#{project.team_memberships.reject{|membership| membership.role.name == "Author" }.map{ | membership |
        #   "#{membership.member.name} (#{membership.role.name})"
        # }.join(",")}\""

        row[7] = authors.map { | author | "#{author.member.name} (#{author.role.name})" }.join(', ')

        row[8] = "#{project.team_members_with_roles_and_pcts.map{ |n| "#{n[:member].name} #{ n[:role_pcts].map{ |role_pcts | "(#{role_pcts[:role]} #{role_pcts[:pct]})"}.join(',')}"  }.join(';')}; Total (#{project.total_team_percent_allocation})"

        row[9] = pgtr.imprint
        unless project.control_number.nil?
          row[10] = project.control_number.asin
          row[11] = project.control_number.paperback_isbn
          row[12] = project.control_number.epub_isbn
        end
        row[13] = project.book_type_pretty

        # look up the publication date that we have in parse via the project's parse_id which matches the ParseBook object_id
        #publication_date_amazon = ParseBooks.find_by_parse_id(project.control_number.parse_id).try(:publication_date_amazon)
        publication_date = unless project.published_file.nil?
          project.published_file.publication_date
        end

        unless publication_date.nil?
          row[14] = publication_date.strftime("%m/%d/%Y")
          row[15] = publication_date.strftime("%B")
          row[16] = publication_date.strftime("%Y")
        end

        row[17] = project.layout.final_page_count unless project.layout.nil?

        row[18] = "$#{"%.2f" % project.publication_fact_sheet.print_price}" unless project.publication_fact_sheet.print_price.nil?
        unless project.publication_fact_sheet.ebook_price.nil?
          row[19] = "$#{"%.2f" % project.publication_fact_sheet.ebook_price}"
          library_price = ApplicationHelper.lookup_library_pricing(project.publication_fact_sheet.ebook_price)
          row[20] = library_price unless library_price.nil?
        end

        unless project.publication_fact_sheet.nil?

          bisac_one = ApplicationHelper.prepare_bisac_code(
            project.publication_fact_sheet.bisac_code_one,
            project.publication_fact_sheet.bisac_code_name_one
          )

          bisac_two = ApplicationHelper.prepare_bisac_code(
            project.publication_fact_sheet.bisac_code_two,
            project.publication_fact_sheet.bisac_code_name_two
          )

          bisac_three = ApplicationHelper.prepare_bisac_code(
            project.publication_fact_sheet.bisac_code_three,
            project.publication_fact_sheet.bisac_code_name_three
          )

          row[21] = bisac_one[:code]
          row[22] = bisac_one[:name]
          row[23] = bisac_two[:code]
          row[24] = bisac_two[:name]
          row[25] = bisac_three[:code]
          row[26] = bisac_three[:name]

          row[27] = project.publication_fact_sheet.search_terms
          row[28] = ApplicationHelper.filter_special_characters(project.publication_fact_sheet.description)    unless project.publication_fact_sheet.description.nil?
          row[29] = ApplicationHelper.filter_special_characters(project.publication_fact_sheet.author_bio)     unless project.publication_fact_sheet.author_bio.nil?
          row[30] = ApplicationHelper.filter_special_characters(project.publication_fact_sheet.one_line_blurb) unless project.publication_fact_sheet.one_line_blurb.nil?
        end

        # generate the csv row by joining the array with ','
        puts row.join(",")
        csv << row
      end
    end

    puts 'sending email...'
    ReportMailer.master_spread_sheet(csv_string, Date.today.strftime('%Y-%m-%d'))
    puts 'done'

  end

end
