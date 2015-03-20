class PublicationFactSheetsController < ApplicationController
  before_action :set_publication_fact_sheet, only: [:show, :edit, :update, :destroy]

  # GET /publication_fact_sheets
  # GET /publication_fact_sheets.json
  def index
    @publication_fact_sheets = PublicationFactSheet.all
  end

  # GET /publication_fact_sheets/1
  # GET /publication_fact_sheets/1.json
  def show
  end

  # GET /publication_fact_sheets/new
  def new
    @publication_fact_sheet = PublicationFactSheet.new
  end

  # GET /publication_fact_sheets/1/edit
  def edit
  end

  # POST /publication_fact_sheets
  # POST /publication_fact_sheets.json
  def create
    @publication_fact_sheet = PublicationFactSheet.new(publication_fact_sheet_params)

    respond_to do |format|
      if @publication_fact_sheet.save
        format.html { redirect_to @publication_fact_sheet, notice: 'Publication fact sheet was successfully created.' }
        format.json { render :show, status: :created, location: @publication_fact_sheet }
      else
        format.html { render :new }
        format.json { render json: @publication_fact_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publication_fact_sheets/1
  # PATCH/PUT /publication_fact_sheets/1.json
  def update
    respond_to do |format|
      if @publication_fact_sheet.update(publication_fact_sheet_params)
        format.html { redirect_to @publication_fact_sheet, notice: 'Publication fact sheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @publication_fact_sheet }
      else
        format.html { render :edit }
        format.json { render json: @publication_fact_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publication_fact_sheets/1
  # DELETE /publication_fact_sheets/1.json
  def destroy
    @publication_fact_sheet.destroy
    respond_to do |format|
      format.html { redirect_to publication_fact_sheets_url, notice: 'Publication fact sheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publication_fact_sheet
      @publication_fact_sheet = PublicationFactSheet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def publication_fact_sheet_params
      params.require(:publication_fact_sheet).permit(:project_id, :author_name, :series_name, :series_number, :description, :author_bio, :endorsements, :one_line_blurb, :print_price, :ebook_price, :bisac_code_one, :bisac_code_two, :bisac_code_three, :search_terms, :age_range, :paperback_cover_type)
    end
end
