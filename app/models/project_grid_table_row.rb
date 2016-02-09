class ProjectGridTableRow < ActiveRecord::Base
  belongs_to :project
  belongs_to :production_task, class_name: "Task"
  belongs_to :marketing_task, class_name: "Task"
  belongs_to :design_task, class_name: "Task"

  scope :published_books, -> {
    joins(:project)
    .includes(project: [:control_number, :publication_fact_sheet, :layout, :published_file, :prefunk_enrollment])
    .where("production_task_name = ?", "Production Complete")
  }

  def generate_master_metadata_export_hash(page_type = :csv)

    # initialize the row_hash with empty data.
    row_hash = {}
    Constants::MasterMetadataHeaderHash.each do | key, value |
      row_hash[key] = ''
    end

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

    row_hash[:other_contributors] = authors.map { | author | "#{author.member.name} (#{author.role.name})" }.join(', ')

    row_hash[:team_and_pct] = "#{project.team_members_with_roles_and_pcts.map{ |n| "#{n[:member].name} #{ n[:role_pcts].map{ |role_pcts | "(#{role_pcts[:role]} #{role_pcts[:pct]})"}.join(',')}"  }.join(';')}; Total (#{project.total_team_percent_allocation})"

    row_hash[:imprint] = imprint
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
