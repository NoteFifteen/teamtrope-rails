class KdpSelectEnrollmentsController < ApplicationController
  before_action :set_kdp_select_enrollment, only: [:show, :edit, :update, :destroy]

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
    respond_with(@kdp_select_enrollment)
  end

  def update
    @kdp_select_enrollment.update(kdp_select_enrollment_params)
    respond_with(@kdp_select_enrollment)
  end

  def destroy
    @kdp_select_enrollment.destroy
    respond_with(@kdp_select_enrollment)
  end

  private
    def set_kdp_select_enrollment
      @kdp_select_enrollment = KdpSelectEnrollment.find(params[:id])
    end

    def kdp_select_enrollment_params
      params.require(:kdp_select_enrollment).permit(:project_id, :member_id, :enrollment_date, :update_type, :update_data)
    end
end
