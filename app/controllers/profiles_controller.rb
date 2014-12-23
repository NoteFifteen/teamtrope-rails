class ProfilesController < ApplicationController
	before_action :set_profile, only: [:edit, :update]
	
	def edit
	end
	
	def update
    if @profile.update_attributes(profile_params)
	    flash[:success] = "Profile updated"
  		if params[:profile][:avatar].blank?
  			if @profile.cropping?
		  		@profile.avatar.reprocess! 
		  	end
	  		redirect_to @profile.user
	  	else
	  		render :action => 'crop'
	  	end
  	else
  		render 'edit'
  	end     	
	end
	
	private
	
		def profile_params
			puts params
			params.require(:profile).permit(:avatar, :crop_x, :crop_y, :crop_w, :crop_h)
		end	
	
		def set_profile
			@profile = Profile.find(params[:id])
			rescue ActiveRecord::RecordNotFound
  			flash[:alert] = "The profile you were looking for could not be found."
  			redirect_to users_path
				
		end
		

end
