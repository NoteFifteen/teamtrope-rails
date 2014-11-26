class StatusesController < ApplicationController

	before_action :signed_in_user, only: [:show, :index, :destroy, :edit]

  def index
  	@statuses = Status.all
  end

  def show
	  @status = Status.find(params[:id])
  end

  def edit
  	@status = Status.find(params[:id])
  end

  def create
    @status = Status.new(status_params)
    if @status.save
      redirect_to @status
    else
      render 'new'
    end  
  end

  def update
	  @status = Status.find(params[:id])
		if @status.update(status_params)
			flash[:success] = "Updated"
			redirect_to @status
		else
			render 'new'
		end
  end

  def new
  	@status = Status.new
  end
  
  def destroy
  	@status = Status.find(params[:id])
    @status.destroy
    flash[:notice] = "Status has been destroyed."
    redirect_to statuses_path
  end
  
  private
		def status_params
			params.require(:status).permit(:form_name,:date,:project_id,:user_id,:entry_id,:process_step)
  	end
end
