class PrefunkEnrollmentsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_prefunk_enrollment, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @prefunk_enrollments = PrefunkEnrollment.all
    respond_with(@prefunk_enrollments)
  end

  def show
    respond_with(@prefunk_enrollment)
  end

  def new
    @prefunk_enrollment = PrefunkEnrollment.new
    respond_with(@prefunk_enrollment)
  end

  def edit
  end

  def create
    @prefunk_enrollment = PrefunkEnrollment.new(prefunk_enrollment_params)
    @prefunk_enrollment.save
    respond_with(@prefunk_enrollment)
  end

  def update
    @prefunk_enrollment.update(prefunk_enrollment_params)
    respond_with(@prefunk_enrollment)
  end

  def destroy
    @prefunk_enrollment.destroy
    respond_with(@prefunk_enrollment)
  end

  def prefunk_scribd_email_report
    @scribd_csv_text = Project.generate_scribd_export_csv(
      Project.generate_scribd_export(
        ProjectGridTableRow.where("project_id in (?)", PrefunkEnrollment.all.map(&:project_id)).sort {| a, b | a.project.book_title <=> b.project.book_title }
      )
    )
    ReportMailer.prefunk_scribd_email_report @scribd_csv_text, current_user
  end

  private
    def set_prefunk_enrollment
      @prefunk_enrollment = PrefunkEnrollment.find(params[:id])
    end

    def set_project
      @project = @prefunk_enrollment.project
    end

    def prefunk_enrollment_params
      params.require(:prefunk_enrollment).permit(:project_id, :user_id)
    end
end
