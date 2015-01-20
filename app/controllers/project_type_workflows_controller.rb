class ProjectTypeWorkflowsController < ApplicationController
  before_action :set_project_type_workflow, only: [:show, :edit, :update, :destroy]

  # GET /project_type_workflows
  # GET /project_type_workflows.json
  def index
    @project_type_workflows = ProjectTypeWorkflow.all
  end

  # GET /project_type_workflows/1
  # GET /project_type_workflows/1.json
  def show
  end

  # GET /project_type_workflows/new
  def new
    @project_type_workflow = ProjectTypeWorkflow.new
  end

  # GET /project_type_workflows/1/edit
  def edit
  end

  # POST /project_type_workflows
  # POST /project_type_workflows.json
  def create
    @project_type_workflow = ProjectTypeWorkflow.new(project_type_workflow_params)

    respond_to do |format|
      if @project_type_workflow.save
        format.html { redirect_to @project_type_workflow, notice: 'Project type workflow was successfully created.' }
        format.json { render :show, status: :created, location: @project_type_workflow }
      else
        format.html { render :new }
        format.json { render json: @project_type_workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_type_workflows/1
  # PATCH/PUT /project_type_workflows/1.json
  def update
    respond_to do |format|
      if @project_type_workflow.update(project_type_workflow_params)
        format.html { redirect_to @project_type_workflow, notice: 'Project type workflow was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_type_workflow }
      else
        format.html { render :edit }
        format.json { render json: @project_type_workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_type_workflows/1
  # DELETE /project_type_workflows/1.json
  def destroy
    @project_type_workflow.destroy
    respond_to do |format|
      format.html { redirect_to project_type_workflows_url, notice: 'Project type workflow was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_type_workflow
      @project_type_workflow = ProjectTypeWorkflow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_type_workflow_params
      params.require(:project_type_workflow).permit(:workflow_id, :project_type_id)
    end
end
