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
        pgtr[ct.task.workflow.name.downcase.gsub(/ /, "_") + "_task_name"] = ct.task.name
        pgtr[ct.task.workflow.name.downcase.gsub(/ /, "_") + "_task_last_update"] = ct.updated_at
      end

      # adding the teamroom_link
      pgtr.teamroom_link = project.teamroom_link

      # adding the title
      pgtr.title = project.title

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

    csv_text = ""
    # building the header
    header = "Project ID,Title,Series Name,Series Number,\"Author (Last,First)\",\"Author (First,Last)\",Other Contributors,Team and Pct,Imprint,Print ISBN,epub ISBN,Format,Publication Date,Month,Year,Page Count,Print Price,Ebook Price(Will vary based on promos and price chagnes),Library Price,BISAC,BISAC2,BISAC3,Search Terms,Summary,Author Bio,Squib"

    # set the row size which is equal to our header row split on the
    row_size = header.gsub(/\".*?,.*?\"/,'').split(',').count

    puts header
    csv_text << header << "\n"

    # fetch all projects that are production complete which indicates that they have been published.
    project_grid_table_rows = ProjectGridTableRow.joins(:project).includes(:project).where("production_task_name = ?", "Production Complete")

    project_grid_table_rows.each do | pgtr |

      row = Array.new(row_size)

      project = pgtr.project

      row[0] = project.id
      row[1] = project.final_title

      unless project.publication_fact_sheet.nil?
        row[2] = project.publication_fact_sheet.series_name
        row[3] = project.publication_fact_sheet.series_number
      end

      # if there are are two authors most likely the main author was the one added first
      # project.authors returns a TeamMembership::ActiveRecord_AssociationRelation so we
      # cannot call order_by but we can use sort.　(what's faster to_a or map? )
      authors = project.authors.to_a.sort{ | a, b | a.created_at <=> b.created_at }

      first_author = authors.slice!(0)

      row[4] = "\"#{first_author.last_name_first}\""
      row[5] = first_author.display_name

      # row[6] = "\"#{project.team_memberships.reject{|membership| membership.role.name == "Author" }.map{ | membership |
      #   "#{membership.member.name} (#{membership.role.name})"
      # }.join(",")}\""

      row[6] = "\"#{authors.map { | author | "#{author.member.name} (#{author.role.name})" }.join(', ')}\""

      row[7] = "\"#{project.team_members_with_roles_and_pcts.map{ |n| "#{n[:member].display_name} #{ n[:role_pcts].map{ |role_pcts | "(#{role_pcts[:role]} #{role_pcts[:pct]})"}.join(',')}"  }.join(';')}\""

      row[8] = pgtr.imprint
      unless project.control_number.nil?
        row[9] = project.control_number.paperback_isbn
        row[10] = project.control_number.epub_isbn
      end
      row[11] = project.book_type_pretty

      # look up the publication date that we have in parse via the project's parse_id which matches the ParseBook object_id
      #publication_date_amazon = ParseBooks.find_by_parse_id(project.control_number.parse_id).try(:publication_date_amazon)
      publication_date = unless project.published_file.nil?
        project.published_file.publication_date
      end

      unless publication_date.nil?
        row[12] = publication_date.strftime("%m/%d/%Y")
        row[13] = publication_date.strftime("%B")
        row[14] = publication_date.strftime("%Y")
      end

      row[15] = project.layout.final_page_count unless project.layout.nil?
      row[16] = "$#{"%.2f" % project.publication_fact_sheet.print_price}" unless project.publication_fact_sheet.print_price.nil?
      unless project.publication_fact_sheet.ebook_price.nil?
        row[17] = "$#{"%.2f" % project.publication_fact_sheet.ebook_price}"
        library_price = lookup_library_pricing(project.publication_fact_sheet.ebook_price)
        row[18] = "$#{"%.2f" % library_price}" unless library_price.nil?
      end

      unless project.publication_fact_sheet.nil?
        row[19] = project.publication_fact_sheet.bisac_code_one
        row[20] = project.publication_fact_sheet.bisac_code_two
        row[21] = project.publication_fact_sheet.bisac_code_three

        row[22] = "\"#{project.publication_fact_sheet.search_terms}\""
        row[23] = "\"#{project.publication_fact_sheet.description.gsub(/\r\n/, " ").gsub(/\n/, " ")}\""
        row[24] = "\"#{project.publication_fact_sheet.author_bio.gsub(/\r\n/, " ").gsub(/\n/, " ")}\""
        row[25] = "\"#{project.publication_fact_sheet.one_line_blurb.gsub(/\r\n/, " ").gsub(/\n/, " ")}\""
      end

      # generate the csv row by joining the array with ','
      puts row.join(",")
      csv_text << row.join(",") << "\n"
    end

    puts 'sending email...'
    ReportMailer.master_spread_sheet(csv_text, Date.today.strftime('%Y-%m-%d'))
    puts 'done'

  end

  PRICE_MAP = {
      0 => 1.5,
      0.99 => 2.5,
      1.99 => 3.5,
      2.99 => 5.45,
      3.99 => 6.75,
      4.99 => 7.95,
      5.99 => 9.25,
      6.99 => 10.50,
      7.99 => 11.95,
      8.99 => 13.25,
      9.99 => 14.5
    }

  def lookup_library_pricing(ebook_price)
    PRICE_MAP[ebook_price]
  end

end
