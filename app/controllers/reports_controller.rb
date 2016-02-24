class ReportsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  def high_allocations
    @percent = params[:percent].nil?? 70.0 : params[:percent]
    @projects = Project.high_allocations @percent
  end

  def no_contracts
    # getting the optimized data set for all projects without contracts.
    @project_grid_table_rows = ProjectGridTableRow
          .includes(:project)
          .where(project_id: Project.with_no_contracts.ids)
          .order(title: :asc)
  end

  def missing_current_tasks
    @projects = Project.missing_current_tasks
  end

  def scribd_metadata_export
    @scribd_metadata_export_items = Project.generate_scribd_export(
      ProjectGridTableRow.published_books.sort { | a, b | a.project.book_title <=> b.project.book_title },
      :html)
    @current_page = request.original_url
  end

  def send_scribd_export_email
    @scribd_csv_text = Project.generate_scribd_export_csv(
      Project.generate_scribd_export(
        ProjectGridTableRow.published_books.sort {| a, b | a.project.book_title <=> b.project.book_title }
      )
    )
    ReportMailer.scribd_email_report @scribd_csv_text, current_user
  end

end
