class DraftBlurbsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :show
  before_action :set_draft_blurb, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

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
    respond_to do | format |
      if @draft_blurb.update(draft_blurb_params)

        @project.create_activity :edited_blurb, owner: current_user,
                                  parameters: { text: 'Edited', object_id: @draft_blurb.id, form_data: params[:draft_blurb].to_s}

        ProjectMailer.submit_blurb(@project, current_user)

        format.html { redirect_to @draft_blurb, notice: 'Draft Blurb was successfully updated.' }
        format.json { render :show, status: :ok, location: @draft_blurb }
      else
        format.html { render :edit }
        format.json { render json: @draft_blurb.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @draft_blurb.destroy
    respond_with(@draft_blurb)
  end

  private
    def set_draft_blurb
      @draft_blurb = DraftBlurb.find(params[:id])
    end

    def set_project
      @project = @draft_blurb.project
    end

    def draft_blurb_params
      params.require(:draft_blurb).permit(:draft_blurb)
    end
end
