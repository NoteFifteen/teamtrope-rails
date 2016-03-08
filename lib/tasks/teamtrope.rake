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
        pgtr[key] = project
          .team_memberships
          .includes(:member)
          .where(role_id: value)
          .map(&:member)
          .map(&:name)
          .join(", ")
      end

      pgtr.prefunk_enrolled = pgtr.project.prefunk_enrollment.nil?? "No" : "Yes"

      unless pgtr.project.prefunk_enrollment.nil?
        pgtr.prefunk_enrollment_date = pgtr.project.prefunk_enrollment.created_at.strftime("%m/%d/%Y")
      end

      # if there are are two authors most likely the main author was the one added first
      authors = project.authors.order(created_at: :asc)

      unless authors.count < 1
        first_author = authors.first
        pgtr.author_last_first = first_author.last_name_first
        pgtr.author_first_last = first_author.member.name

        pgtr.other_contributors = authors.reject{ | a |
          a.id == first_author.id
        }.map { | author |
          "#{author.member.name} (#{author.role.name})"
        }.join(', ')
      end

      pgtr.team_and_pct = "#{
        project.team_members_with_roles_and_pcts.map{ |n|
          "#{n[:member].name} #{
            n[:role_pcts].map{ |role_pcts |
              "(#{role_pcts[:role]} #{role_pcts[:pct]})"}.join(',')
            }" }.join(';')
          }; Total (#{project.total_team_percent_allocation})"

      unless pgtr.project.control_number.nil?
        pgtr.asin = project.control_number.asin
        pgtr.paperback_isbn = project.control_number.paperback_isbn
        pgtr.epub_isbn = project.control_number.epub_isbn
      end

      unless pgtr.project.publication_fact_sheet.nil?

        pgtr.series_name   = pgtr.project.publication_fact_sheet.series_name
        pgtr.series_number = pgtr.project.publication_fact_sheet.series_number

        pgtr.pfs_author_name = pgtr.project.publication_fact_sheet.author_name

        pgtr.formatted_print_price = "$#{"%.2f" % pgtr.project.publication_fact_sheet.print_price}" unless pgtr.project.publication_fact_sheet.print_price.nil?
        unless pgtr.project.publication_fact_sheet.ebook_price.nil?
          pgtr.formatted_ebook_price = "$#{"%.2f" % pgtr.project.publication_fact_sheet.ebook_price}"
          library_price = ApplicationHelper.lookup_library_pricing(pgtr.project.publication_fact_sheet.ebook_price)
          pgtr.formatted_library_price = library_price unless library_price.nil?
        end

        # todo: refactor this mess!
        bisac_one = ApplicationHelper.prepare_bisac_code(
          project.publication_fact_sheet.bisac_code_one,
          project.publication_fact_sheet.bisac_code_name_one
        )

        pgtr.bisac_one_code = bisac_one[:code]
        pgtr.bisac_one_description = bisac_one[:name]

        bisac_two = ApplicationHelper.prepare_bisac_code(
          project.publication_fact_sheet.bisac_code_two,
          project.publication_fact_sheet.bisac_code_name_two
        )

        pgtr.bisac_two_code = bisac_one[:code]
        pgtr.bisac_two_description = bisac_one[:name]

        bisac_three = ApplicationHelper.prepare_bisac_code(
          project.publication_fact_sheet.bisac_code_three,
          project.publication_fact_sheet.bisac_code_name_three
        )

        pgtr.bisac_three_code = bisac_one[:code]
        pgtr.bisac_three_description = bisac_one[:name]


        pgtr.search_terms   = project.publication_fact_sheet.search_terms
        pgtr.description    = ApplicationHelper.filter_special_characters(project.publication_fact_sheet.description)    unless project.publication_fact_sheet.description.nil?
        pgtr.author_bio     = ApplicationHelper.filter_special_characters(project.publication_fact_sheet.author_bio)     unless project.publication_fact_sheet.author_bio.nil?
        pgtr.one_line_blurb = ApplicationHelper.filter_special_characters(project.publication_fact_sheet.one_line_blurb) unless project.publication_fact_sheet.one_line_blurb.nil?
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

      publication_date = unless pgtr.project.published_file.nil?
        pgtr.project.published_file.publication_date
      end

      unless publication_date.nil?
        pgtr.publication_date = publication_date
      end

      pgtr.page_count = pgtr.project.layout.final_page_count unless pgtr.project.layout.nil?

      # book format
      pgtr.book_format = project.book_type_pretty

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
