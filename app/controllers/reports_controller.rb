class ReportsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  def high_allocations
    @percent = params[:percent].nil?? 70.0 : params[:percent]
    @projects = Project.high_allocations @percent
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

  def master_metadata
    @master_metadata_export = Project.generate_master_meta_export(
      ProjectGridTableRow.published_books.sort { | a, b | a.project.book_title <=> b.project.book_title }
    )
  end

  def master_metadata_export
    csv_string = Project.generate_master_meta_export_csv(
      Project.generate_master_meta_export(
        ProjectGridTableRow.published_books.sort { | a, b | a.project.book_title <=> b.project.book_title }
      )
    )

    ReportMailer.master_spread_sheet(csv_string, Date.today.strftime('%Y-%m-%d %H:%M:%S'))
  end

end
