class CurrentTasksController < ApplicationController
  before_action :set_current_task, only: [:show, :edit, :update, :destroy]

  # GET /current_tasks
  # GET /current_tasks.json
  def index
    @current_tasks = CurrentTask.all
  end

  # GET /current_tasks/1
  # GET /current_tasks/1.json
  def show
  end

  # GET /current_tasks/new
  def new
    @current_task = CurrentTask.new
  end

  # GET /current_tasks/1/edit
  def edit
  end

  # POST /current_tasks
  # POST /current_tasks.json
  def create
    @current_task = CurrentTask.new(current_task_params)

    respond_to do |format|
      if @current_task.save
        format.html { redirect_to @current_task, notice: 'Current task was successfully created.' }
        format.json { render :show, status: :created, location: @current_task }
      else
        format.html { render :new }
        format.json { render json: @current_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /current_tasks/1
  # PATCH/PUT /current_tasks/1.json
  def update
    respond_to do |format|
      if @current_task.update(current_task_params)
        format.html { redirect_to @current_task, notice: 'Current task was successfully updated.' }
        format.json { render :show, status: :ok, location: @current_task }
      else
        format.html { render :edit }
        format.json { render json: @current_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /current_tasks/1
  # DELETE /current_tasks/1.json
  def destroy
    @current_task.destroy
    respond_to do |format|
      format.html { redirect_to current_tasks_url, notice: 'Current task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_current_task
      @current_task = CurrentTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def current_task_params
      params.require(:current_task).permit(:project_id, :task_id)
    end
end
