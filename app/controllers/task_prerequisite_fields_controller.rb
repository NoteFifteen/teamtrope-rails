class TaskPrerequisiteFieldsController < ApplicationController
  before_action :set_task_prerequisite_field, only: [:show, :edit, :update, :destroy]

  # GET /task_prerequisite_fields
  # GET /task_prerequisite_fields.json
  def index
    @task_prerequisite_fields = TaskPrerequisiteField.all
  end

  # GET /task_prerequisite_fields/1
  # GET /task_prerequisite_fields/1.json
  def show
  end

  # GET /task_prerequisite_fields/new
  def new
    @task_prerequisite_field = TaskPrerequisiteField.new
  end

  # GET /task_prerequisite_fields/1/edit
  def edit
  end

  # POST /task_prerequisite_fields
  # POST /task_prerequisite_fields.json
  def create
    @task_prerequisite_field = TaskPrerequisiteField.new(task_prerequisite_field_params)

    respond_to do |format|
      if @task_prerequisite_field.save
        format.html { redirect_to @task_prerequisite_field, notice: 'Task prerequisite field was successfully created.' }
        format.json { render :show, status: :created, location: @task_prerequisite_field }
      else
        format.html { render :new }
        format.json { render json: @task_prerequisite_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_prerequisite_fields/1
  # PATCH/PUT /task_prerequisite_fields/1.json
  def update
    respond_to do |format|
      if @task_prerequisite_field.update(task_prerequisite_field_params)
        format.html { redirect_to @task_prerequisite_field, notice: 'Task prerequisite field was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_prerequisite_field }
      else
        format.html { render :edit }
        format.json { render json: @task_prerequisite_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_prerequisite_fields/1
  # DELETE /task_prerequisite_fields/1.json
  def destroy
    @task_prerequisite_field.destroy
    respond_to do |format|
      format.html { redirect_to task_prerequisite_fields_url, notice: 'Task prerequisite field was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_prerequisite_field
      @task_prerequisite_field = TaskPrerequisiteField.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_prerequisite_field_params
      params.require(:task_prerequisite_field).permit(:workflow_step_id, :field_name)
    end
end
