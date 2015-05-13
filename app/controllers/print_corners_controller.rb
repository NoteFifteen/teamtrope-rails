class PrintCornersController < ApplicationController
  before_action :set_print_corner, only: [:show, :edit, :update, :destroy]

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
    @print_corner.update(print_corner_params)
    respond_with(@print_corner)
  end

  def destroy
    @print_corner.destroy
    respond_with(@print_corner)
  end

  private
    def set_print_corner
      @print_corner = PrintCorner.find(params[:id])
    end

    def print_corner_params
      params.require(:print_corner).permit(:project_id, :user_id, :order_type, :first_order, :additional_order, :over_125, :billing_acceptance, :quantity, :has_author_profile, :has_marketing_plan, :shipping_recipient, :shipping_address_street_1, :shipping_address_street_2, :shipping_address_city, :shipping_address_state, :shipping_address_zip, :marketing_plan_link, :marketing_copy_message, :contact_phone, :expedite_instructions)
    end
end
