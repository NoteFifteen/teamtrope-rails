class DataRepairController < ApplicationController

  before_action :signed_in_user
  before_action :booktrope_staff


  def home
  end

  def repair_data
    case params[:type]
    when 'prices'
      repair_prices
    when 'isbn'
      repair_isbn
    else
    end
  end

  def handle_csv(csv_file_path)
    require 'csv'
    csv = CSV.parse(csv_file_path.read, headers: :first_row)
    csv.each do | row |
      yield(row)
    end
  end

  def repair_isbn
    @updated_projects = []
    handle_csv(params[:upload_file]) do | row |
      csv_paperback_isbn = row["ot"]

      # csv encoding is quoted-printable so we need to force UTF 8 encoding on the title otherwise we
      # get a nice incompatible encoding error when rendering the view.
      result_hash = {
        updated: false,
        project_id: nil,
        book_type: "Unknown",
        column_name: 'paperback_isbn',
        title: row["Title"].nil?? "" : row["Title"].force_encoding(Encoding::UTF_8),
        updated_field: csv_paperback_isbn,
      }

      @updated_projects << result_hash

      if csv_paperback_isbn.nil? || csv_paperback_isbn.strip == ""
        result_hash[:reason] = "no paperback_isbn provided"
        next
      end

      control_number = ControlNumber.where(paperback_isbn: csv_paperback_isbn.gsub(/-/, '').strip).includes(:project).first

      previously_updated = false

      # they might want to run the tool several times with the same file so we should also look for the one with the dash.
      if control_number.nil?
        control_number = ControlNumber.where(paperback_isbn: csv_paperback_isbn.strip).includes(:project).first
        result_hash[:reason] = "Previously Updated"
        previously_updated = true
      end

      if control_number.nil?
        result_hash[:reason] = "no project found for #{csv_paperback_isbn}"
        next
      end

      project = control_number.project

      result_hash[:project] = project
      result_hash[:book_type] = project.book_type
      result_hash[:title] = project.book_title


      puts "found! #{control_number.id}\t#{project.book_title}"

      unless previously_updated
        control_number.paperback_isbn = csv_paperback_isbn
        control_number.save
        result_hash[:updated] = true
      end

    end
  end

  def repair_prices
    @updated_projects = []

    handle_csv(params[:upload_file]) do | row |
      result_hash = {
        updated: false,
        project_id: row["project_id"],
        book_type: row["book_type"],
        title: row["title"],
        column_name: 'print_price',
        updated_field: row["print_price"]
      }

      ebook_hash = result_hash.clone
      ebook_hash[:column_name] = 'ebook_price'
      ebook_hash[:updated_field] = row['ebook_price']

      @updated_projects << result_hash
      @updated_projects << ebook_hash

      if row["project_id"].nil? || row["project_id"].strip == ""
        result_hash[:reason] = "No project_id"
        next
      end

      project = Project.find(row["project_id"])

      # getting the real information from the DB maybe it changed since.
      result_hash[:project] = project
      result_hash[:title] = project.book_title
      result_hash[:book_type] = project.book_type

      ebook_hash[:project] = project
      ebook_hash[:title] = project.book_title
      ebook_hash[:book_type] = project.book_type

      if row["print_price"].nil? || row["print_price"].strip == ""
        result_hash[:reason] = "No print_price #{row["print_price"]}"
      else
        project.publication_fact_sheet.print_price = row["print_price"].gsub(/\$/, '')
        result_hash[:updated] = true
      end

      if row["ebook_price"].nil? || row["ebook_price"].strip == ""
        ebook_hash[:reason] = "No ebook_price #{row["ebook_price"]}"
      else
        project.publication_fact_sheet.ebook_price = row["ebook_price"].gsub(/\$/, '')
        ebook_hash[:updated] = true
      end

      # update the pfs we updated either the ebook or print price.
      project.publication_fact_sheet.save if project.publication_fact_sheet.print_price_changed? || project.publication_fact_sheet.ebook_price_changed?

    end
  end

end
