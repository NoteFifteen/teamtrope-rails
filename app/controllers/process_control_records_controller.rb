class ProcessControlRecordsController < ApplicationController
	before_action :signed_in_user, only: [:show, :index, :destroy, :edit]

  def show
	  @pcr = ProcessControlRecord.find(params[:id])
  end

  def index
  	@pcrs = ProcessControlRecord.all
  end

  def create
	  @pcr = ProcessControlRecord.new(process_control_record_params)
  	if @pcr.save
  		flash[:success] = "New PCR Created!"
  		redirect_to @pcr
  	else
  		render 'new'
  	end	  
  end

  def new
  	@pcr = ProcessControlRecord.new
  end

  def update
	  @pcr = ProcessControlRecord.find(params[:id])
		if @pcr.update(process_control_record_params)
			flash[:success] = "Updated"
			redirect_to @pcr
		else
			render 'new'
		end	  
  end

  def edit
  	@pcr = ProcessControlRecord.find(params[:id])
  end
  
  def destroy
	  @pcr = ProcessControlRecord.find(params[:id])
    @pcr.destroy
    flash[:notice] = "PCR has been destroyed."
    redirect_to process_control_records_path
  end
  
  private
  	def process_control_record_params
			params.require(:process_control_record).permit(:days_to_complete_book,:intro_video,:who_can_complete,:is_approval_step,:days_to_complete_step,:not_approved_go_to,:tab_text,:help_link,:step_name,:form_name,:prereq_fields,:show_steps,:workflow,:icon,:phase,:next_step,:is_process_step)
  	end
end
