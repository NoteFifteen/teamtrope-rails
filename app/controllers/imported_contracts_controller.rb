class ImportedContractsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: [:create, :show]
  before_action :set_imported_contract, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @imported_contracts = ImportedContract.all
    respond_with(@imported_contracts)
  end

  def show
    respond_with(@imported_contract)
  end

  def new
    @imported_contract = ImportedContract.new
    respond_with(@imported_contract)
  end

  def edit
  end

  def create
    # load up the project that our newly imported contract belongs to
    @project = Project.friendly.find(params[:project_id])

    # create a new imported_contract 
    @imported_contract = @project.imported_contracts.create()
    @updated_file = nil
    update_hash = {}

    if ! params[:imported_contract].nil?
      update_hash[:contract_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:contract_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:contract_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:contract_direct_upload_url] = params[:imported_contract]['direct_upload_url'] unless params[:imported_contract]['direct_upload_url'].nil?
      update_hash[:contract_processed] = false
      @updated_file = 'imported_contract'
    end

    @imported_contract.update(update_hash)
    @imported_contract.save
    @last_errors = @imported_contract.errors.full_messages
    return
  end

  def update
    @imported_contract.update(imported_contract_params)
    respond_with(@imported_contract)
  end

  def destroy
    @imported_contract.destroy
    respond_with(@imported_contract)
  end

  private
    def set_imported_contract
      @imported_contract = ImportedContract.find(params[:id])
    end

    def set_project
      @project = @imported_contract.project
    end

    def imported_contract_params
      params.require(:imported_contract).permit(:document_type, :document_signers, :document_date, :contract)
    end
end
