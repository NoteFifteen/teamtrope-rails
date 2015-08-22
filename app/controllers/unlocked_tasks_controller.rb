class UnlockedTasksController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_unlocked_task, only: [:show, :edit, :update, :destroy]

  # GET /unlocked_tasks
  # GET /unlocked_tasks.json
  def index
    @unlocked_tasks = UnlockedTask.all
  end

  # GET /unlocked_tasks/1
  # GET /unlocked_tasks/1.json
  def show
  end

  # GET /unlocked_tasks/new
  def new
    @unlocked_task = UnlockedTask.new
  end

  # GET /unlocked_tasks/1/edit
  def edit
  end

  # POST /unlocked_tasks
  # POST /unlocked_tasks.json
  def create
    @unlocked_task = UnlockedTask.new(unlocked_task_params)

    respond_to do |format|
      if @unlocked_task.save
        format.html { redirect_to @unlocked_task, notice: 'Unlocked task was successfully created.' }
        format.json { render :show, status: :created, location: @unlocked_task }
      else
        format.html { render :new }
        format.json { render json: @unlocked_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unlocked_tasks/1
  # PATCH/PUT /unlocked_tasks/1.json
  def update
    respond_to do |format|
      if @unlocked_task.update(unlocked_task_params)
        format.html { redirect_to @unlocked_task, notice: 'Unlocked task was successfully updated.' }
        format.json { render :show, status: :ok, location: @unlocked_task }
      else
        format.html { render :edit }
        format.json { render json: @unlocked_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unlocked_tasks/1
  # DELETE /unlocked_tasks/1.json
  def destroy
    @unlocked_task.destroy
    respond_to do |format|
      format.html { redirect_to unlocked_tasks_url, notice: 'Unlocked task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unlocked_task
      @unlocked_task = UnlockedTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unlocked_task_params
      params.require(:unlocked_task).permit(:task_id, :unlocked_task_id)
    end
end
