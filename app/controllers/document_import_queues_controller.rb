class DocumentImportQueuesController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_document_import_queue, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @document_import_queues = DocumentImportQueue.all
    respond_with(@document_import_queues)
  end

  def show
    respond_with(@document_import_queue)
  end

  def new
    @document_import_queue = DocumentImportQueue.new
    respond_with(@document_import_queue)
  end

  def edit
  end

  def create
    @document_import_queue = DocumentImportQueue.new(document_import_queue_params)
    @document_import_queue.save
    respond_with(@document_import_queue)
  end

  def update
    @document_import_queue.update(document_import_queue_params)
    respond_with(@document_import_queue)
  end

  def destroy
    @document_import_queue.destroy
    respond_with(@document_import_queue)
  end

  private
    def set_document_import_queue
      @document_import_queue = DocumentImportQueue.find(params[:id])
    end

    def document_import_queue_params
      params.require(:document_import_queue).permit(:wp_id, :attachment_id, :fieldname, :url, :status, :dyno_id, :error)
    end
end
