class ImprintsController < ApplicationController
  before_action :set_imprint, only: [:show, :edit, :update, :destroy]

  # GET /imprints
  # GET /imprints.json
  def index
    @imprints = Imprint.all
  end

  # GET /imprints/1
  # GET /imprints/1.json
  def show
  end

  # GET /imprints/new
  def new
    @imprint = Imprint.new
  end

  # GET /imprints/1/edit
  def edit
  end

  # POST /imprints
  # POST /imprints.json
  def create
    @imprint = Imprint.new(imprint_params)

    respond_to do |format|
      if @imprint.save
        format.html { redirect_to @imprint, notice: 'Imprint was successfully created.' }
        format.json { render :show, status: :created, location: @imprint }
      else
        format.html { render :new }
        format.json { render json: @imprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /imprints/1
  # PATCH/PUT /imprints/1.json
  def update
    respond_to do |format|
      if @imprint.update(imprint_params)
        format.html { redirect_to @imprint, notice: 'Imprint was successfully updated.' }
        format.json { render :show, status: :ok, location: @imprint }
      else
        format.html { render :edit }
        format.json { render json: @imprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imprints/1
  # DELETE /imprints/1.json
  def destroy
    @imprint.destroy
    respond_to do |format|
      format.html { redirect_to imprints_url, notice: 'Imprint was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_imprint
      @imprint = Imprint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def imprint_params
      params.require(:imprint).permit(:name)
    end
end
