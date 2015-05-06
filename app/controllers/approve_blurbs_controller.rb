class ApproveBlurbsController < ApplicationController
  before_action :set_approve_blurb, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @approve_blurbs = ApproveBlurb.all
    respond_with(@approve_blurbs)
  end

  def show
    respond_with(@approve_blurb)
  end

  def new
    @approve_blurb = ApproveBlurb.new
    respond_with(@approve_blurb)
  end

  def edit
  end

  def create
    @approve_blurb = ApproveBlurb.new(approve_blurb_params)
    @approve_blurb.save
    respond_with(@approve_blurb)
  end

  def update
    @approve_blurb.update(approve_blurb_params)
    respond_with(@approve_blurb)
  end

  def destroy
    @approve_blurb.destroy
    respond_with(@approve_blurb)
  end

  private
    def set_approve_blurb
      @approve_blurb = ApproveBlurb.find(params[:id])
    end

    def approve_blurb_params
      params.require(:approve_blurb).permit(:project_id, :blurb_notes, :blurb_approval_decision, :blurb_approval_date)
    end
end
