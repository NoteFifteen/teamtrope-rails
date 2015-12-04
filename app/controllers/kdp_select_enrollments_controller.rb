class KdpSelectEnrollmentsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :show
  before_action :set_kdp_select_enrollment, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @kdp_select_enrollments = KdpSelectEnrollment.all
    respond_with(@kdp_select_enrollments)
  end

  def show
    respond_with(@kdp_select_enrollment)
  end

  def new
    @kdp_select_enrollment = KdpSelectEnrollment.new
    respond_with(@kdp_select_enrollment)
  end

  def edit
  end

  def create
    @kdp_select_enrollment = KdpSelectEnrollment.new(kdp_select_enrollment_params)
    @kdp_select_enrollment.save

    # Even though it shouldn't be possible to create a new enrollment from here, I wanted to include
    # the necessary code since this function for create already exists. [BR]
    @kdp_select_enrollment.project.create_activity :kdp_select_enrolled, owner: current_user,
                                                   parameters: { text: 'Enrolled in KDP Select', form_data: params[:project].to_s}

    ProjectMailer.kdp_select_enrollment(@kdp_select_enrollment.project, current_user)

    respond_with(@kdp_select_enrollment)
  end

  def update
    if @kdp_select_enrollment.update(kdp_select_enrollment_params)
        @project.create_activity :edited_kdp_select_enrollment, owner: current_user,
                                 parameters: { text: 'Edited', object_id: @kdp_select_enrollment.id, form_data: kdp_select_enrollment_params.to_s}

        ProjectMailer.kdp_select_update(@project, current_user)
    end

    respond_with(@kdp_select_enrollment)
  end

  def destroy
    @kdp_select_enrollment.destroy

    @kdp_select_enrollment.project.create_activity :kdp_select_withdrawn, owner: current_user,
                                                   parameters: { text: 'Withdrew enrollment in KDP Select', form_data: params[:project].to_s}

    ProjectMailer.kdp_withdraw_enrollment(@project, current_user)

    respond_with(@kdp_select_enrollment)
  end

  private
    def set_kdp_select_enrollment
      @kdp_select_enrollment = KdpSelectEnrollment.find(params[:id])
    end

    def set_project
      @project = @kdp_select_enrollment.project
    end

    def kdp_select_enrollment_params
      params.require(:project).require(:kdp_select_enrollment_attributes).permit(:project_id, :member_id, :enrollment_date, :update_type, :update_data)
    end
end
