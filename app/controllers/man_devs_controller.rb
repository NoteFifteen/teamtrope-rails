class ManDevsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_man_dev, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @man_devs = ManDev.all
    respond_with(@man_devs)
  end

  def show
    respond_with(@man_dev)
  end

  def new
    @man_dev = ManDev.new
    respond_with(@man_dev)
  end

  def edit
  end

  def create
    @man_dev = ManDev.new(man_dev_params)
    @man_dev.save
    respond_with(@man_dev)
  end

  def update
    @man_dev.update(man_dev_params)
    respond_with(@man_dev)
  end

  def destroy
    @man_dev.destroy
    respond_with(@man_dev)
  end

  private
    def set_man_dev
      @man_dev = ManDev.find(params[:id])
    end

    def man_dev_params
      params.require(:man_dev).permit(:project_id, :man_dev_decision, :man_dev_end_date)
    end
end
