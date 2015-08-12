class ControlNumbersController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :show
  before_action :set_control_number, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @control_numbers = ControlNumber.all
    respond_with(@control_numbers)
  end

  def show
    respond_with(@control_number)
  end

  def new
    @control_number = ControlNumber.new
    respond_with(@control_number)
  end

  def edit
  end

  def create
    @control_number = ControlNumber.new(control_number_params)
    @control_number.save
    respond_with(@control_number)
  end

  def update
    @control_number.update(control_number_params)

    Booktrope::ParseWrapper.update_project_control_numbers(@control_number)

    @project.create_activity :updated_control_numbers, owner: current_user,
                             parameters: {text: "Edited the Control Numbers", form_data: params[:control_number].to_s }



    ProjectMailer.edit_control_numbers(@project, current_user)
    respond_with(@control_number)
  end

  def destroy
    @control_number.destroy
    respond_with(@control_number)
  end

  private
    def set_control_number
      @control_number = ControlNumber.find(params[:id])
    end

    def set_project
      @project = @control_number.project
    end

    def control_number_params
      params.require(:control_number).permit(:asin, :apple_id, :epub_isbn, :paperback_isbn, :hardback_isbn)
    end
end
