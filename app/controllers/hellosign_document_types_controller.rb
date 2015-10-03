class HellosignDocumentTypesController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_hellosign_document_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @hellosign_document_types = HellosignDocumentType.all
    respond_with(@hellosign_document_types)
  end

  def show
    respond_with(@hellosign_document_type)
  end

  def new
    @hellosign_document_type = HellosignDocumentType.new
    respond_with(@hellosign_document_type)
  end

  def edit
  end

  def create
    @hellosign_document_type = HellosignDocumentType.new(hellosign_document_type_params)
    @hellosign_document_type.save
    respond_with(@hellosign_document_type)
  end

  def update
    @hellosign_document_type.update(hellosign_document_type_params)
    respond_with(@hellosign_document_type)
  end

  def destroy
    @hellosign_document_type.destroy
    respond_with(@hellosign_document_type)
  end

  private
    def set_hellosign_document_type
      @hellosign_document_type = HellosignDocumentType.find(params[:id])
    end

    def hellosign_document_type_params
      params.require(:hellosign_document_type).permit(:name, :subject, :message, :template_id, :signers, :ccs)
    end
end
