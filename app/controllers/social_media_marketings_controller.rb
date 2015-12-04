class SocialMediaMarketingsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :show
  before_action :set_social_media_marketing, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @social_media_marketings = SocialMediaMarketing.all
    respond_with(@social_media_marketings)
  end

  def show
    respond_with(@social_media_marketing)
  end

  def new
    @social_media_marketing = SocialMediaMarketing.new
    respond_with(@social_media_marketing)
  end

  def edit
  end

  def create
    @social_media_marketing = SocialMediaMarketing.new(social_media_marketing_params)
    @social_media_marketing.save
    respond_with(@social_media_marketing)
  end

  def update
    if @social_media_marketing.update(social_media_marketing_params)
        @project.create_activity :edited_social_media_marketing, owner: current_user,
                                 parameters: { text: 'Edited', object_id: @social_media_marketing.id, form_data: social_media_marketing_params.to_s}
        ProjectMailer.update_social_media_marketing(@project, current_user)

    end
    respond_with(@social_media_marketing)
  end

  def destroy
    @social_media_marketing.destroy
    respond_with(@social_media_marketing)
  end

  private
    def set_social_media_marketing
      @social_media_marketing = SocialMediaMarketing.find(params[:id])
    end

    def set_project
      @project = @social_media_marketing.project
    end

    def social_media_marketing_params
      params.require(:social_media_marketing).permit(:project_id, :author_facebook_page, :author_central_account_link, :website_url, :twitter, :pintrest, :goodreads)
    end
end
