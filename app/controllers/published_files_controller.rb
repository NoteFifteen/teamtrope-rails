class PublishedFilesController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_published_file, only: [:show, :edit, :update, :destroy]

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

  # POST /published_files
  # POST /published_files.json
  def create
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

  # PATCH/PUT /published_files/1
  # PATCH/PUT /published_files/1.json
  def update
    respond_to do |format|
      if @published_file.update(published_file_params)
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def published_file_params
      params.require(:published_file).permit(:publication_date, :mobi, :epub, :pdf)
    end
end
