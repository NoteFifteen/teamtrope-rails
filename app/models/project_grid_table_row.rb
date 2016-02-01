class ProjectGridTableRow < ActiveRecord::Base
  belongs_to :project
  belongs_to :production_task, class_name: "Task"
  belongs_to :marketing_task, class_name: "Task"
  belongs_to :design_task, class_name: "Task"

  scope :published_books, -> {
    joins(:project)
    .includes(project: [:control_number, :publication_fact_sheet, :layout, :published_file])
    .where("production_task_name = ?", "Production Complete")
  }

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

    row_hash
  end

  def set_task_display_name(workflow, name)
    puts self["#{workflow}_task_id"]
    task = Task.find self["#{workflow}_task_id"]
    self["#{workflow}_task_display_name"] = name
  end
end
