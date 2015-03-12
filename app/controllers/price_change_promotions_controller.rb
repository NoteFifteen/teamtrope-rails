class PriceChangePromotionsController < ApplicationController
  before_action :set_price_change_promotion, only: [:show, :edit, :update, :destroy]

  # GET /price_change_promotions
  # GET /price_change_promotions.json
  def index
    @price_change_promotions = PriceChangePromotion.all
  end

  # GET /price_change_promotions/1
  # GET /price_change_promotions/1.json
  def show
  end

  # GET /price_change_promotions/new
  def new
    @price_change_promotion = PriceChangePromotion.new
  end

  # GET /price_change_promotions/1/edit
  def edit
  end

  # POST /price_change_promotions
  # POST /price_change_promotions.json
  def create
    @price_change_promotion = PriceChangePromotion.new(price_change_promotion_params)

    respond_to do |format|
      if @price_change_promotion.save
        format.html { redirect_to @price_change_promotion, notice: 'Price change promotion was successfully created.' }
        format.json { render :show, status: :created, location: @price_change_promotion }
      else
        format.html { render :new }
        format.json { render json: @price_change_promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /price_change_promotions/1
  # PATCH/PUT /price_change_promotions/1.json
  def update
    respond_to do |format|
      if @price_change_promotion.update(price_change_promotion_params)
        format.html { redirect_to @price_change_promotion, notice: 'Price change promotion was successfully updated.' }
        format.json { render :show, status: :ok, location: @price_change_promotion }
      else
        format.html { render :edit }
        format.json { render json: @price_change_promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /price_change_promotions/1
  # DELETE /price_change_promotions/1.json
  def destroy
    @price_change_promotion.destroy
    respond_to do |format|
      format.html { redirect_to price_change_promotions_url, notice: 'Price change promotion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price_change_promotion
      @price_change_promotion = PriceChangePromotion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_change_promotion_params
      params.require(:price_change_promotion).permit(:start_date, :end_date, :price_promotion, :price_after_promotion, :type_mask, :sites, :project_id)
    end
end
