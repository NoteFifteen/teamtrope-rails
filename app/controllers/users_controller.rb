class UsersController < ApplicationController

  before_action :signed_in_user, only: [:show, :index, :destroy, :edit, :activity]
  before_action :correct_user,   only: [:edit, :update]


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Teamtrope!"
      if params[:user][:avatar].blank?
	      redirect_to @user
	    else
	    	render :action => 'crop'
	    end
    else
      render 'new'
    end
  end

  def edit
  end

  def update    
    if @user.update_attributes(user_params)
	    flash[:success] = "Profile updated"
  		if params[:user][:avatar].blank?
  			if @user.cropping?
		  		@user.avatar.reprocess! 
		  	end
	  		redirect_to @user
	  	else
	  		render :action => 'crop'
	  	end
  	else
  		render 'edit'
  	end     
  end
  
  #TODO: Implement activity
  def activity
  	@user = User.find(params[:id])
  end
  
  #TODO: Implement mentions
  def mentions
  	@user = User.find(params[:id])
  end
  
  #TODO: Implement groups
  def groups
  	@user = User.find(params[:id])
  end
  
  #TODO: Implement favorites
  def favorites
  	@user = User.find(params[:id])
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :crop_x, :crop_y, :crop_w, :crop_h)
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    #def admin_user
    #  redirect_to(root_url) unless current_user.admin?
    #end
  
end
