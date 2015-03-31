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
  
  #TODO: maybe move this to another controller and path in routes.rb
  def box_request_access
  
  	authorize! :manage, BoxCredential
  	anti_forgery_token = SecureRandom.urlsafe_base64(16)
  	BoxCredential.create! anti_forgery_token: anti_forgery_token
  	
		redirect_to Boxr::oauth_url(anti_forgery_token, 
					box_client_id: Figaro.env.box_client_id).to_s
		
  end
  
  #TODO: maybe move this to another controller and path in routes.rb
  def box_redirect
  
	  authorize! :manage, BoxCredential
  	box_credentials = BoxCredential.where(anti_forgery_token: params[:state]).first
  	
  	unless box_credentials.nil?
	  	tokens = Boxr::get_tokens(params[:code],
	  				grant_type: 'authorization_code',
	  				box_client_id: Figaro.env.box_client_id,
	  				box_client_secret: Figaro.env.box_client_secret)
  						  					  					
	  	if box_credentials.update(access_token: tokens['access_token'],
  						refresh_token: tokens['refresh_token'])
  			puts "success"
	  	else
  			puts "failure"
	  	end
	  	
  	else
  	  	redirect_to root_path 
  	end
  	
  end
  
end
