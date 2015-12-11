class RightsBackRequestsController < ApplicationController
  before_action :set_rights_back_request, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @rights_back_requests = RightsBackRequest.all
    respond_with(@rights_back_requests)
  end

  def show
    respond_with(@rights_back_request)
  end

  def new
    @rights_back_request = RightsBackRequest.new
    respond_with(@rights_back_request)
  end

  def edit
  end

  def create
    @rights_back_request = RightsBackRequest.new(rights_back_request_params)
    @rights_back_request.save
    respond_with(@rights_back_request)
  end

  def update
    @rights_back_request.update(rights_back_request_params)
    respond_with(@rights_back_request)
  end

  def destroy
    @rights_back_request.destroy
    respond_with(@rights_back_request)
  end

  private
    def set_rights_back_request
      @rights_back_request = RightsBackRequest.find(params[:id])
    end

    def rights_back_request_params
      params.require(:rights_back_request).permit(:project_id, :submitted_by_id, :integer, :title, :author, :book_format, :reason, :roles, :published, :accepted_agreement)
    end
end
