class NetgalleySubmissionsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :show
  before_action :set_netgalley_submission, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @netgalley_submissions = NetgalleySubmission.all
    respond_with(@netgalley_submissions)
  end

  def show
    respond_with(@netgalley_submission)
  end

  def new
    @netgalley_submission = NetgalleySubmission.new
    respond_with(@netgalley_submission)
  end

  def edit
  end

  def create
    @netgalley_submission = NetgalleySubmission.new(netgalley_submission_params)
    @netgalley_submission.save
    respond_with(@netgalley_submission)
  end

  def update

    if @netgalley_submission.update(netgalley_submission_params)

      @project.create_activity :edited_netgalley_submission, owner: current_user,
                               parameters: {
                                    text: "Edited Netgalley Submission",
                                    object_id: @netgalley_submission.id,
                                    form_data: params[:netgalley_submission].to_s
                              }

      ProjectMailer.new_netgalley_submission(@project, current_user)
      flash[:success] = 'Updated Netgalley Submission'
    else
      flash[:danger] = 'There was problem updating the Netgalley Submission'
    end

    respond_with(@netgalley_submission)
  end

  def destroy
    @netgalley_submission.destroy
    respond_with(@netgalley_submission)
  end

  private
    def set_netgalley_submission
      @netgalley_submission = NetgalleySubmission.find(params[:id])
    end

    def set_project
      @project = @netgalley_submission.project
    end

    def netgalley_submission_params
      params.require(:netgalley_submission).permit(:project_id, :title, :author_name, :publication_date, :retail_price, :blurb, :website_one, :website_two, :website_three, :category_one, :category_two, :praise, :isbn)
    end
end
