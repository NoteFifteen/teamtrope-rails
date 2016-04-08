class ProjectGridTableRow < ActiveRecord::Base
  belongs_to :project
  belongs_to :production_task, class_name: "Task"
  belongs_to :marketing_task, class_name: "Task"
  belongs_to :design_task, class_name: "Task"

  scope :published_books, -> {
    where("production_task_name = ?", "Production Complete")
  }

  scope :excude_rights_returned, -> {
    published_books.where.not(project: Project.joins(:rights_back_request))
  }

  scope :not_archived, -> {
    where(archived: false)
  }

  scope :archived, -> {
    where(archived: true)
  }

  def self.generate_master_metadata_export_hash(pgtr, page_type = :csv)

    # initialize the row_hash with a clone of the header hash
    row_hash = Constants::MasterMetadataHeaderHash.clone

    row_hash[:project_id]              = pgtr.project_id
    row_hash[:prefunk]                 = pgtr.prefunk_enrolled
    row_hash[:prefunk_enrollment_date] = pgtr.prefunk_enrollment_date

    row_hash[:title]                   = pgtr.title
    row_hash[:series_name]             = pgtr.series_name
    row_hash[:series_number]           = pgtr.series_number

    row_hash[:author_last_first]       = pgtr.author_last_first
    row_hash[:author_first_last]       = pgtr.author_first_last
    row_hash[:pfs_author_name]         = pgtr.pfs_author_name
    row_hash[:other_contributors]      = pgtr.other_contributors
    row_hash[:team_and_pct]            = pgtr.team_and_pct
    row_hash[:imprint]                 = pgtr.imprint

    row_hash[:asin]                    = pgtr.asin
    row_hash[:print_isbn]              = pgtr.paperback_isbn
    row_hash[:epub_isbn]               = pgtr.epub_isbn
    row_hash[:format]                  = pgtr.book_format

    unless pgtr.publication_date.nil?
      row_hash[:publication_date]      = pgtr.publication_date.strftime("%m/%d/%Y")
      row_hash[:month]                 = pgtr.publication_date.strftime("%B")
      row_hash[:year]                  = pgtr.publication_date.strftime("%Y")
    end

    row_hash[:page_count]              = pgtr.page_count

    row_hash[:print_price]             = pgtr.formatted_print_price
    row_hash[:ebook_price]             = pgtr.formatted_ebook_price
    row_hash[:library_price]           = pgtr.formatted_library_price

    row_hash[:bisac_one]               = pgtr.bisac_one_code
    row_hash[:bisac_one_description]   = pgtr.bisac_one_description
    row_hash[:bisac_two]               = pgtr.bisac_two_code
    row_hash[:bisac_two_description]   = pgtr.bisac_two_description
    row_hash[:bisac_three]             = pgtr.bisac_three_code
    row_hash[:bisac_three_description] = pgtr.bisac_three_description

    row_hash[:search_terms]            = pgtr.search_terms
    row_hash[:summary]                 = pgtr.description
    row_hash[:author_bio]              = pgtr.author_bio
    row_hash[:squib]                   = pgtr.one_line_blurb

    row_hash[:authors_pct]             = pgtr.authors_pct
    row_hash[:editors_pct]             = pgtr.editors_pct
    row_hash[:book_managers_pct]       = pgtr.book_managers_pct
    row_hash[:cover_designers_pct]     = pgtr.cover_designers_pct
    row_hash[:project_managers_pct]    = pgtr.project_managers_pct
    row_hash[:proofreaders_pct]        = pgtr.proofreaders_pct
    row_hash[:total_pct]               = pgtr.total_pct

    row_hash.each do | key, value |
      if value.class == String
        row_hash[key] = ApplicationHelper.filter_special_characters(value)
      end
    end

    row_hash
  end

  def generate_scribd_export_hash(page_type = :csv)
    # using the Scribd data hash as our base we will override the header info
    # with real data clone is a deep copy otherwise we overrite the constant :'(
    row_hash = Constants::ScribdCsvHeaderHash.clone

    publication_fact_sheet = project.publication_fact_sheet

    row_hash[:project_id] = project.id
    row_hash[:imprint] = "Booktrope"

    parent_isbn, ebook_isbn = ApplicationHelper.scribd_prepare_isbn(project.control_number)

    row_hash[:parent_isbn] = parent_isbn.empty?? nil : parent_isbn
    row_hash[:ebook_isbn] = ebook_isbn.empty?? nil : ebook_isbn

    row_hash[:format] = "EPUB"
    row_hash[:filename] = ebook_isbn.empty?? nil : ebook_isbn + ".epub"
    row_hash[:title] = project.book_title
    row_hash[:project] = project if page_type != :csv
    row_hash[:subtitle] = nil

    row_hash[:authors] = author

    publication_date = unless project.published_file.nil? || project.published_file.publication_date.nil?
      project.published_file.publication_date.strftime("%m/%d/%Y")
    end

    row_hash[:publication_date] = publication_date
    row_hash[:street_date] = publication_date

    digital_list_price = unless project.publication_fact_sheet.nil? || project.publication_fact_sheet.ebook_price.nil?
      price = project.publication_fact_sheet.ebook_price
      price = 1 if price < 1 && price > 0
      "$#{"%.2f" % price}"
    end

    row_hash[:digital_list_price] = digital_list_price
    row_hash[:currency] = "USD"

    row_hash[:permitted_sales_territories] = "WORLD"
    row_hash[:excluded_sales_territories] = nil

    row_hash[:short_description] = ApplicationHelper.filter_special_characters(project.publication_fact_sheet.description) unless project.publication_fact_sheet.nil? || project.publication_fact_sheet.description.nil?

    bisac_codes = []

    unless publication_fact_sheet.nil?
      ["one", "two", "three"].each do | suffix |
        bisac_code = ApplicationHelper.prepare_bisac_code(
          publication_fact_sheet["bisac_code_#{suffix}"],
          publication_fact_sheet["bisac_code_name_#{suffix}"]
        )
        bisac_codes << bisac_code[:code] unless bisac_code[:code].nil? || bisac_code[:code].empty?
      end
    end

    row_hash[:bisac_categories] = bisac_codes.join(",")
    row_hash[:number_of_pages] = project.layout.final_page_count unless project.layout.nil?
    row_hash[:series] = (publication_fact_sheet.nil? || publication_fact_sheet.series_name.nil? || publication_fact_sheet.series_name.empty?)? nil : publication_fact_sheet.series_name
    row_hash[:delete] = nil
    row_hash[:direct_purchase] = nil
    row_hash[:subscription] = nil
    row_hash[:preview_percent] = "10%"
    row_hash[:language] = "eng"
    row_hash[:genre] = genre
    row_hash[:enrollment_date] = ! project.prefunk_enrollment.nil?? project.prefunk_enrollment.created_at : nil
    row_hash[:asin] = project.control_number.asin unless project.control_number.nil?
    row_hash[:amazon_link] = (!project.control_number.nil? && !project.control_number.asin.nil?)? "http://amzn.com/#{project.control_number.asin}" : ""
    row_hash[:apple_id] = project.control_number.apple_id unless project.control_number.nil?


    filter_report_data(row_hash)
  end

  def set_task_display_name(workflow, name)
    puts self["#{workflow}_task_id"]
    task = Task.find self["#{workflow}_task_id"]
    self["#{workflow}_task_display_name"] = name
  end

  private
  def filter_report_data(row_hash)
    row_hash.each do | key, value |
      row_hash[key] = ApplicationHelper.filter_special_characters(value) if value.class == String
    end
    row_hash
  end
end
