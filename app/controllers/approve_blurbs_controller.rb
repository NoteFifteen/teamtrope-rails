class ApproveBlurbsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :show
  before_action :set_approve_blurb, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

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

    respond_to do | format|

      if @approve_blurb.update(approve_blurb_params)

        @project.create_activity :edited_approve_blurb, owner: current_user,
                               parameters: { text: "Edited", form_data: params[:project].to_s }

        ProjectMailer.approve_blurb(@project, current_user, @approve_blurb.blurb_approval_decision)

        format.html { redirect_to @approve_blurb, notice: "Updated Approve Blurb" }
        format.json { render :show, status: :ok, location: @approve_blurb }
      else
        format.html { render :edit }
        format.json { render json: @approve_blurb.errors, status: :unprocessable_entity }
      end

    end

    #respond_with(@approve_blurb)
  end

  def destroy
    @approve_blurb.destroy
    respond_with(@approve_blurb)
  end

  private
    def set_approve_blurb
      @approve_blurb = ApproveBlurb.find(params[:id])
    end

    def set_project
      @project = @approve_blurb.project
    end

    def approve_blurb_params
      params.require(:approve_blurb).permit(:project_id, :blurb_notes, :blurb_approval_decision, :blurb_approval_date)
    end
end
