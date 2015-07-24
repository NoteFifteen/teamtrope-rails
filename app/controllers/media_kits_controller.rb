class MediaKitsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :create
  before_action :set_media_kit, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @media_kits = MediaKit.all
    respond_with(@media_kits)
  end

  def show
    respond_with(@media_kit)
  end

  def new
    @media_kit = MediaKit.new
    respond_with(@media_kit)
  end

  def edit
  end

  def create
    @project = Project.friendly.find(params[:project_id])

    @media_kit = MediaKit.find_or_initialize_by(project_id: @project.id)
    @updated_file = nil
    update_hash = {}

    if !params[:media_kit_document].nil?
      update_hash[:document_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''

      update_hash[:document_content_type] = params[:filetype].nil?? 'application/pdf' : params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:document_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize].nil? || params[:filesize] == ''
      update_hash[:document_direct_upload_url] = params[:media_kit_document]['direct_upload_url'] unless params[:media_kit_document]['direct_upload_url'].nil?
      @updated_file = 'document'
    end

    @media_kit.update(update_hash)
    @media_kit.save
    @last_errors = @media_kit.errors.full_messages
  end

  def update
    @media_kit.update(media_kit_params)
    respond_with(@media_kit)
  end

  def destroy
    @media_kit.destroy
    respond_with(@media_kit)
  end

  private
    def set_media_kit
      @media_kit = MediaKit.find(params[:id])
    end

    def set_project
      @media_kit ||= set_media_kit
      @project = @media_kit.project
    end

    def media_kit_params
      params.permit(:document)
    end
end
