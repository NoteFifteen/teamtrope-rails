class ArtworkRightsRequestsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_artwork_rights_request, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @artwork_rights_requests = ArtworkRightsRequest.all
    respond_with(@artwork_rights_requests)
  end

  def show
    respond_with(@artwork_rights_request)
  end

  def new
    @artwork_rights_request = ArtworkRightsRequest.new
    respond_with(@artwork_rights_request)
  end

  def edit
  end

  def create
    @artwork_rights_request = ArtworkRightsRequest.new(artwork_rights_request_params)
    @artwork_rights_request.save
    respond_with(@artwork_rights_request)
  end

  def update

    respond_to do | format |
      if @artwork_rights_request.update(artwork_rights_request_params)

        @project.create_activity :edited_artwork_rights_request, owner: current_user,
                               parameters: { text: 'Edited', object_id: @artwork_rights_request.id, form_data: params[:artwork_rights_request].to_s}
        ProjectMailer.artwork_rights_request(@project, current_user)

        format.html { redirect_to @artwork_rights_request, notice: "Updated the Artwork Rights Request" }
        format.json { render :show, status: :ok, location: @artwork_rights_request }
      else
        format.html { render :edit }
        format.json { render json: @artwork_rights_request.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    @artwork_rights_request.destroy
    respond_with(@artwork_rights_request)
  end

  private
    def set_artwork_rights_request
      @artwork_rights_request = ArtworkRightsRequest.find(params[:id])
    end

    def set_project
      @project = @artwork_rights_request.project
    end

    def artwork_rights_request_params
      params.require(:artwork_rights_request).permit(:email, :full_name, :role_type)
    end
end
