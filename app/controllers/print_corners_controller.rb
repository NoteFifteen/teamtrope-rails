class PrintCornersController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :show
  before_action :set_print_corner, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @print_corners = PrintCorner.all
    respond_with(@print_corners)
  end

  def show
    respond_with(@print_corner)
  end

  def new
    @print_corner = PrintCorner.new
    respond_with(@print_corner)
  end

  def edit
  end

  def create
    @print_corner = PrintCorner.new(print_corner_params)
    @print_corner.save
    respond_with(@print_corner)
  end

  def update
    respond_to do | format |
      if @print_corner.update(print_corner_params)

        @project.create_activity :edited_print_corner_request, owner: current_user,
                               parameters: { text: 'Edited', object_id: @print_corner.id, form_data: params[:print_corner]}
        ProjectMailer.print_corner_request(@project, current_user)
        format.html { redirect_to @print_corner, notice: "Print Corner was successfully updated." }
        format.json { render :show, status: :ok, location: @print_corner }

      else
        format.html { render :edit }
        format.json { render json: @prrint_corner.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @print_corner.destroy
    respond_with(@print_corner)
  end

  private
    def set_print_corner
      @print_corner = PrintCorner.find(params[:id])
    end

    def set_project
      @project = @print_corner.project
    end

    def print_corner_params
      params.require(:print_corner).permit(:project_id, :user_id, :order_type, :first_order, :additional_order, :over_125, :billing_acceptance, :quantity, :has_author_profile, :has_marketing_plan, :shipping_recipient, :shipping_address_street_1, :shipping_address_street_2, :shipping_address_city, :shipping_address_state, :shipping_address_zip, :marketing_plan_link, :marketing_copy_message, :contact_phone, :expedite_instructions)
    end
end
