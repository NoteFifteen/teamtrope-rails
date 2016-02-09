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
