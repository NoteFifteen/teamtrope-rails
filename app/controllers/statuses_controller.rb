class StatusesController < ApplicationController

	before_action :signed_in_user, only: [:show, :index, :destroy, :edit]
	before_action :set_status,     only: [:show, :edit, :update, :destroy]
	
  def index
  	@statuses = Status.all
  end

  def show
  end

  def edit
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
		if @status.update(status_params)
			flash[:success] = "Updated"
			redirect_to @status
		else
			render 'edit'
		end
  end

  def new
  	@status = Status.new
  end
  
  def destroy
    @status.destroy
    flash[:notice] = "Status has been destroyed."
    redirect_to statuses_path
  end
  
  private
		def status_params
			params.require(:status).permit(:form_name,:date,:project_id,:user_id,:entry_id,:process_step)
  	end
  	
  	def set_status
  		@status = Status.find(params[:id])
	  	rescue ActiveRecord::RecordNotFound
  			flash[:alert] = "The status you were looking for could not be found."
  			redirect_to statuses_path
  	end
end
