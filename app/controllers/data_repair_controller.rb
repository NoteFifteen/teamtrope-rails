class DataRepairController < ApplicationController

  before_action :signed_in_user
  before_action :booktrope_staff


  def home

  end

  def print_price
    @updated_projects = []

    require 'csv'
    csv = CSV.parse(params[:upload_file].read, headers: :first_row)
    total = 0

    csv.each do | row |

      result_hash = {
        updated: false,
        project_id: row["project_id"],
        book_type: row["book_type"],
        title: row["title"],
        print_price: row["submitted_price"]
      }

      @updated_projects << result_hash

      next if row["project_id"].nil? || row["project_id"].strip == ""

      project = Project.find(row["project_id"])

      # getting the real information from the DB maybe it changed since.
      result_hash[:project] = project
      result_hash[:title] = project.book_title
      result_hash[:book_type] = project.book_type

      next if row["submitted_price"].nil? || row["submitted_price"].strip == ""

      project.publication_fact_sheet.print_price = row["submitted_price"]
      project.publication_fact_sheet.save

      result_hash[:updated] = true

    end
  end

end
