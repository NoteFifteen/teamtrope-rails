class StaticPagesController < ApplicationController
  def home
  	if !signed_in?
  		redirect_to visitors_path
  	else
  		redirect_to posts_path
  	end
  end
  
  def visitors
  end
end
