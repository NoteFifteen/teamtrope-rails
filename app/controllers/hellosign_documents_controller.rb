class HellosignDocumentsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_hellosign_document, only: [:show, :edit, :update, :destroy, :cancel_signature_request]

  respond_to :html, :js

  def index
    @hellosign_documents = HellosignDocument.all
    respond_with(@hellosign_documents)
  end

  def show
    respond_with(@hellosign_document)
  end

  def new
    @hellosign_document = HellosignDocument.new
    respond_with(@hellosign_document)
  end

  def edit
  end

  def create
    @hellosign_document = HellosignDocument.new(hellosign_document_params)
    @hellosign_document.save
    respond_with(@hellosign_document)
  end

  def update
    @hellosign_document.update(hellosign_document_params)
    respond_with(@hellosign_document)
  end

  def destroy
    @hellosign_document.destroy
    respond_with(@hellosign_document)
  end

  def cancel_signature_request
    CancelRequestJob.create hellosign_document_id: @hellosign_document.id
    respond_with(@hellosign_document)
  end

  private
    def set_hellosign_document
      @hellosign_document = HellosignDocument.find(params[:id])
    end

    def hellosign_document_params
      params.require(:hellosign_document).permit(:hellosign_id, :status, :hellosign_document_type_id)
    end
end
