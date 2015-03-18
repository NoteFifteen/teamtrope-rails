class BlogToursController < ApplicationController
  before_action :set_blog_tour, only: [:show, :edit, :update, :destroy]

  # GET /blog_tours
  # GET /blog_tours.json
  def index
    @blog_tours = BlogTour.all
  end

  # GET /blog_tours/1
  # GET /blog_tours/1.json
  def show
  end

  # GET /blog_tours/new
  def new
    @blog_tour = BlogTour.new
  end

  # GET /blog_tours/1/edit
  def edit
  end

  # POST /blog_tours
  # POST /blog_tours.json
  def create
    @blog_tour = BlogTour.new(blog_tour_params)

    respond_to do |format|
      if @blog_tour.save
        format.html { redirect_to @blog_tour, notice: 'Blog tour was successfully created.' }
        format.json { render :show, status: :created, location: @blog_tour }
      else
        format.html { render :new }
        format.json { render json: @blog_tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blog_tours/1
  # PATCH/PUT /blog_tours/1.json
  def update
    respond_to do |format|
      if @blog_tour.update(blog_tour_params)
        format.html { redirect_to @blog_tour, notice: 'Blog tour was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog_tour }
      else
        format.html { render :edit }
        format.json { render json: @blog_tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_tours/1
  # DELETE /blog_tours/1.json
  def destroy
    @blog_tour.destroy
    respond_to do |format|
      format.html { redirect_to blog_tours_url, notice: 'Blog tour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_tour
      @blog_tour = BlogTour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_tour_params
      params.require(:blog_tour).permit(:project_id, :cost, :tour_type, :blog_tour_service, :number_of_stops, :start_date, :end_date)
    end
end
