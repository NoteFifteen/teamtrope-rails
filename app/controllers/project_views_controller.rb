class ProjectViewsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_project_view, only: [:show, :edit, :update, :destroy]

  # GET /project_views
  # GET /project_views.json
  def index
    @project_views = ProjectView.all
  end

  # GET /project_views/1
  # GET /project_views/1.json
  def show
  end

  # GET /project_views/new
  def new
    @project_view = ProjectView.new
  end

  # GET /project_views/1/edit
  def edit
  end

  # POST /project_views
  # POST /project_views.json
  def create
    @project_view = ProjectView.new(new_project_view_params)

    respond_to do |format|
      if @project_view.save
        format.html { redirect_to @project_view, notice: 'Project view was successfully created.' }
        format.json { render :show, status: :created, location: @project_view }
      else
        format.html { render :new }
        format.json { render json: @project_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_views/1
  # PATCH/PUT /project_views/1.json
  def update
    respond_to do |format|
      if @project_view.update(edit_project_view_params)
        format.html { redirect_to @project_view, notice: 'Project view was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_view }
      else
        format.html { render :edit }
        format.json { render json: @project_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_views/1
  # DELETE /project_views/1.json
  def destroy
    @project_view.destroy
    respond_to do |format|
      format.html { redirect_to project_views_url, notice: 'Project view was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_view
      @project_view = ProjectView.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def new_project_view_params
      params.require(:project_view).permit(:project_type_id, phases_attributes: [:name, :order, :color, :color_value, :icon, tabs_attributes: [:task_id, :phase_id, :order]])
    end

    def edit_project_view_params
      params.require(:project_view).permit(:project_type_id, phases_attributes: [:name, :order, :color, :color_value, :icon, :id, :_destroy, tabs_attributes: [:task_id, :phase_id, :order, :id, :_destroy]])
    end
end
