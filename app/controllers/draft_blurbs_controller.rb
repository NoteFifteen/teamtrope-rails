class DraftBlurbsController < ApplicationController
  before_action :set_draft_blurb, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @draft_blurbs = DraftBlurb.all
    respond_with(@draft_blurbs)
  end

  def show
    respond_with(@draft_blurb)
  end

  def new
    @draft_blurb = DraftBlurb.new
    respond_with(@draft_blurb)
  end

  def edit
  end

  def create
    @draft_blurb = DraftBlurb.new(draft_blurb_params)
    @draft_blurb.save
    respond_with(@draft_blurb)
  end

  def update
    @draft_blurb.update(draft_blurb_params)
    respond_with(@draft_blurb)
  end

  def destroy
    @draft_blurb.destroy
    respond_with(@draft_blurb)
  end

  private
    def set_draft_blurb
      @draft_blurb = DraftBlurb.find(params[:id])
    end

    def draft_blurb_params
      params.require(:draft_blurb).permit(:project_id, :draft_blurb)
    end
end
