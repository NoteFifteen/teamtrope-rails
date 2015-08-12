class TaskPerformersController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_task_performer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @task_performers = TaskPerformer.all
    respond_with(@task_performers)
  end

  def show
    respond_with(@task_performer)
  end

  def new
    @task_performer = TaskPerformer.new
    respond_with(@task_performer)
  end

  def edit
  end

  def create
    @task_performer = TaskPerformer.new(task_performer_params)
    @task_performer.save
    respond_with(@task_performer)
  end

  def update
    @task_performer.update(task_performer_params)
    respond_with(@task_performer)
  end

  def destroy
    @task_performer.destroy
    respond_with(@task_performer)
  end

  private
    def set_task_performer
      @task_performer = TaskPerformer.find(params[:id])
    end

    def task_performer_params
      params[:task_performer]
    end
end
