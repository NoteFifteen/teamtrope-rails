class PublishedFilesController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_published_file, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /published_files
  # GET /published_files.json
  def index
    @published_files = PublishedFile.all
  end

  # GET /published_files/1
  # GET /published_files/1.json
  def show
  end

  # GET /published_files/new
  def new
    @published_file = PublishedFile.new
  end

  # GET /published_files/1/edit
  def edit
  end

  # This is the default generated create method which was not used since we prefer that published files be added
  # directly from within the Project.
  #
  # POST /published_files
  # POST /published_files.json
  def create_default
    @published_file = PublishedFile.new(published_file_params)

    respond_to do |format|
      if @published_file.save
        format.html { redirect_to @published_file, notice: 'Published file was successfully created.' }
        format.json { render :show, status: :created, location: @published_file }
      else
        format.html { render :new }
        format.json { render json: @published_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # This controller method is hit remotely via AJAX from a Project view.
  def create
    @project = Project.friendly.find(params[:project_id])

    # All examples (and code, really) seem to prefer a controller per file, whereas the PublishedFile model
    # is for a single set of three documents, so we have to do some janky stuff here to make it work.
    @published_file = PublishedFile.find_or_initialize_by(project_id: @project.id)
    @updated_file = nil
    update_hash = {}

    if ! params[:published_file_mobi].nil?
      update_hash[:mobi_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''

      # Sometimes these files are not provided with the content-type
      update_hash[:mobi_content_type] = (params[:filetype].nil?) ? 'application/octet-stream' : params[:filetype]

      update_hash[:mobi_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:mobi_direct_upload_url] = params[:published_file_mobi]['direct_upload_url'] unless params[:published_file_mobi]['direct_upload_url'].nil?
      @updated_file = 'mobi'
    end

    if ! params[:published_file_epub].nil?
      update_hash[:epub_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:epub_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:epub_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:epub_direct_upload_url] = params[:published_file_epub]['direct_upload_url'] unless params[:published_file_epub]['direct_upload_url'].nil?
      @updated_file = 'epub'
    end

    if ! params[:published_file_pdf].nil?
      update_hash[:pdf_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:pdf_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:pdf_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:pdf_direct_upload_url] = params[:published_file_pdf]['direct_upload_url'] unless params[:published_file_pdf]['direct_upload_url'].nil?
      @updated_file = 'pdf'
    end

    @published_file.update(update_hash)
    @published_file.save
    @last_errors = @published_file.errors.full_messages
    return
  end

  # PATCH/PUT /published_files/1
  # PATCH/PUT /published_files/1.json
  def update
    respond_to do |format|
      if @published_file.update(published_file_params)
        @project.create_activity :published_book, owner: current_user,
                                  parameters: { text: 'Submitted the Publish Book form', form_data: params[:published_file].to_s}

        format.html { redirect_to @published_file, notice: 'Published file was successfully updated.' }
        format.json { render :show, status: :ok, location: @published_file }
      else
        format.html { render :edit }
        format.json { render json: @published_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /published_files/1
  # DELETE /published_files/1.json
  def destroy
    @published_file.destroy
    respond_to do |format|
      format.html { redirect_to published_files_url, notice: 'Published file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_published_file
      @published_file = PublishedFile.find(params[:id])
    end

    def set_project
      @project = PublishedFile.find(params[:id]).project
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def published_file_params
      params.require(:published_file).permit(:publication_date, :mobi, :epub, :pdf)
    end
end
