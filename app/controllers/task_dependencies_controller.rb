class TaskDependenciesController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_task_dependency, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @task_dependencies = TaskDependency.all
    respond_with(@task_dependencies)
  end

  def show
    respond_with(@task_dependency)
  end

  def new
    @task_dependency = TaskDependency.new
    respond_with(@task_dependency)
  end

  def edit
  end

  def create
    @task_dependency = TaskDependency.new(task_dependency_params)
    @task_dependency.save
    respond_with(@task_dependency)
  end

  def update
    @task_dependency.update(task_dependency_params)
    respond_with(@task_dependency)
  end

  def destroy
    @task_dependency.destroy
    respond_with(@task_dependency)
  end

  private
    def set_task_dependency
      @task_dependency = TaskDependency.find(params[:id])
    end

    def task_dependency_params
      params.require(:task_dependency).permit(:main_task_id, :dependent_task_id)
    end
end
