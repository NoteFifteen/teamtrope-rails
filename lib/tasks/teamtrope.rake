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

    csv_header = {
      project_id: "Project ID",
      prefunk: "Prefunk",
      prefunk_enrollment_date: "Prefunk Enrollment Date",
      title: "Title",
      series_name: "Series Name",
      series_number: "Series Number",
      author_last_first: "Author (Last,First)",
      author_first_last: "Author (First,Last)",
      pfs_author_name: "PFS Author Name",
      other_contributors: "Other Contributors",
      team_and_pct: "Team and Pct",
      imprint: "Imprint",
      asin: "ASIN",
      print_isbn: "Print ISBN",
      epub_isbn: "epub ISBN",
      format: "Format",
      publication_date: "Publication Date",
      month: "Month",
      year: "Year",
      page_count: "Page Count",
      print_price: "Print Price",
      ebook_price: "Ebook Price(Will vary based on promos and price changes)",
      library_price: "Library Price",
      bisac_one: "BISAC",
      bisac_one_description: "BISAC Description",
      bisac_two: "BISAC2",
      bisac_two_description: "BISAC Description 2",
      bisac_three: "BISAC3",
      bisac_three_description: "BISAC Description 3",
      search_terms: "Search Terms",
      summary: "Summary",
      author_bio: "Author Bio",
      squib: "Squib" }


    csv_string = CSV.generate do |csv|

      csv << csv_header.values

      # fetch all projects that are production complete which indicates that they have been published.
      project_grid_table_rows = ProjectGridTableRow.published_books

      project_grid_table_rows.each do | pgtr |

        # initialize the row_hash with empty data.
        row_hash = {}
        csv_header.each do | key, value |
          row_hash[key] = ''
        end

        project = pgtr.project

        row_hash[:project_id] = project.id
        row_hash[:prefunk] = project.prefunk_enrollment.nil?? "No" : "Yes"
        row_hash[:prefunk_enrollment_date] = project.prefunk_enrollment.created_at unless project.prefunk_enrollment.nil?
        row_hash[:title] = project.book_title

        unless project.publication_fact_sheet.nil?
          row_hash[:series_name] = project.publication_fact_sheet.series_name
          row_hash[:series_number] = project.publication_fact_sheet.series_number
        end

        # if there are are two authors most likely the main author was the one added first
        # project.authors returns a TeamMembership::ActiveRecord_AssociationRelation so we
        # cannot call order_by but we can use sort.　(what's faster to_a or map? )
        authors = project.authors.to_a.sort{ | a, b | a.created_at <=> b.created_at }

        first_author = authors.slice!(0)

        row_hash[:author_last_first] = first_author.last_name_first
        row_hash[:author_first_last] = first_author.member.name

        row_hash[:pfs_author_name] = project.publication_fact_sheet.author_name

        # row[6] = "\"#{project.team_memberships.reject{|membership| membership.role.name == "Author" }.map{ | membership |
        #   "#{membership.member.name} (#{membership.role.name})"
        # }.join(",")}\""

        row_hash[:other_contributors] = authors.map { | author | "#{author.member.name} (#{author.role.name})" }.join(', ')

        row_hash[:team_and_pct] = "#{project.team_members_with_roles_and_pcts.map{ |n| "#{n[:member].name} #{ n[:role_pcts].map{ |role_pcts | "(#{role_pcts[:role]} #{role_pcts[:pct]})"}.join(',')}"  }.join(';')}; Total (#{project.total_team_percent_allocation})"

        row_hash[:imprint] = pgtr.imprint
        unless project.control_number.nil?
          row_hash[:asin] = project.control_number.asin
          row_hash[:print_isbn] = project.control_number.paperback_isbn
          row_hash[:epub_isbn] = project.control_number.epub_isbn
        end
        row_hash[:format] = project.book_type_pretty

        # look up the publication date that we have in parse via the project's parse_id which matches the ParseBook object_id
        #publication_date_amazon = ParseBooks.find_by_parse_id(project.control_number.parse_id).try(:publication_date_amazon)
        publication_date = unless project.published_file.nil?
          project.published_file.publication_date
        end

        unless publication_date.nil?
          row_hash[:publication_date] = publication_date.strftime("%m/%d/%Y")
          row_hash[:month] = publication_date.strftime("%B")
          row_hash[:year] = publication_date.strftime("%Y")
        end

        row_hash[:page_count] = project.layout.final_page_count unless project.layout.nil?

        row_hash[:print_price] = "$#{"%.2f" % project.publication_fact_sheet.print_price}" unless project.publication_fact_sheet.print_price.nil?
        unless project.publication_fact_sheet.ebook_price.nil?
          row_hash[:ebook_price] = "$#{"%.2f" % project.publication_fact_sheet.ebook_price}"
          library_price = ApplicationHelper.lookup_library_pricing(project.publication_fact_sheet.ebook_price)
          row_hash[:library_price] = library_price unless library_price.nil?
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

          row_hash[:bisac_one] = bisac_one[:code]
          row_hash[:bisac_one_description] = bisac_one[:name]
          row_hash[:bisac_two] = bisac_two[:code]
          row_hash[:bisac_two_description] = bisac_two[:name]
          row_hash[:bisac_three] = bisac_three[:code]
          row_hash[:bisac_three_description] = bisac_three[:name]

          row_hash[:search_terms] = project.publication_fact_sheet.search_terms
          row_hash[:summary] = ApplicationHelper.filter_special_characters(project.publication_fact_sheet.description)    unless project.publication_fact_sheet.description.nil?
          row_hash[:author_bio] = ApplicationHelper.filter_special_characters(project.publication_fact_sheet.author_bio)     unless project.publication_fact_sheet.author_bio.nil?
          row_hash[:squib] = ApplicationHelper.filter_special_characters(project.publication_fact_sheet.one_line_blurb) unless project.publication_fact_sheet.one_line_blurb.nil?
        end

        row_hash.each do | key, value |
          row_hash[key] = ApplicationHelper.filter_special_characters(value) if value.class == String
        end

        csv << row_hash.values
      end
    end

    puts 'sending email...'
    ReportMailer.master_spread_sheet(csv_string, Date.today.strftime('%Y-%m-%d'))
    puts 'done'

  end

  desc "Fixes the print price for books"
  task fix_print_price: :environment do
    require 'csv'
    require 'pp'

    published_projects = ProjectGridTableRow.published_books.map(&:project)

    published_project_ids = published_projects.map(&:id)
    missing_print_price = PublicationFactSheet.where("project_id in (?) and (print_price is null or print_price = 0.0 )", published_project_ids).includes(:project)

    missing_count = missing_print_price.count

    updated = []
    needs_updating = []

    missing_print_price.each do | pfs |
      project = pfs.project

      report_meta = {
        project_id: project.id,
        book_type: project.book_type,
        title: project.book_title,
        url: "projects.teamtrope.com/projects/#{project.slug}",
      }

      # fetching the activity record for this project: project.updated_final_page_count
      activity_record, print_price = get_updated_final_page_count_activity(project)

      report_meta[:submitted_price] = print_price
      report_meta[:activity_type] = "updated_final_page_count"

      # if no activity exists it may have been submitted on the PFS which is where it used to be submitted
      # project.submitted_pfs
      if activity_record.nil? || print_price.nil?
        activity_record, print_price = get_submitted_pfs_activity(project)
        report_meta[:submitted_price] = print_price
        report_meta[:activity_type] = "submitted_pfs"
        #puts "\t#{activity_record.created_at}\t#{print_price}\t#{activity_record.parameters[:form_data]}" unless activity_record.nil?
      end

      # updating the meta data for our report if we found public activity
      unless activity_record.nil?
        report_meta[:submit_date] = activity_record.created_at
        report_meta[:form_data] = activity_record.parameters[:form_data]
      end

      # upate unless we have nil, blank or 0 for our price.
      unless print_price.nil? || print_price.strip == "" || print_price.to_i == 0
        project.publication_fact_sheet.print_price = print_price
        project.publication_fact_sheet.save
        updated.push report_meta
      else
        needs_updating.push report_meta
      end
    end

    updated_report = generate_csv updated
    needs_updating_report = generate_csv needs_updating

    puts "Updated: #{updated.count} out of #{missing_count}"

    ReportMailer.print_price_update(updated_report, needs_updating_report)
  end

  def generate_csv(report_list)
    csv_header = [ "project_id", "book_type", "title", "url", "submitted_price", "activity_type", "form_submit_date", "form_data" ]
    CSV.generate do |csv|
      csv << csv_header

      report_list.each do | report_hash |
        csv << [
          report_hash[:project_id],
          report_hash[:book_type],
          report_hash[:title],
          report_hash[:url],
          report_hash[:submitted_price],
          report_hash[:activity_type],
          report_hash[:submit_date],
          report_hash[:form_data]
        ]
      end
    end
  end

  def extract_print_price(activity_record)
    print_price = unless activity_record.nil?
      /"print_price"=>"(?<submitted_price>.*?)"/i =~ activity_record.parameters[:form_data]
      submitted_price
    end
  end

  def get_updated_final_page_count_activity(project)
    activity_record = PublicActivity::Activity.where(trackable_id: project.id, key: "project.updated_final_page_count").order(created_at: :desc).first
    [activity_record, extract_print_price(activity_record)]
  end

  def get_submitted_pfs_activity(project)
    activity_record = PublicActivity::Activity.where(trackable_id: project.id, key: "project.submitted_pfs").order(created_at: :desc).first
    [activity_record, extract_print_price(activity_record)]
  end

end
