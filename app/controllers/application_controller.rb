class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  after_filter :store_location

  def store_location
      return unless request.get?
      if (request.path != '/users/sign_in' &&
          request.path != '/users/sign_up' &&
          request.path != '/users/password/new' &&
          request.path != '/users/password/edit' &&
          request.path != '/users/confirmation' &&
          request.path != '/users/sign_out' &&
          !request.xhr?) # don't store ajax calls
        session[:previous_url] = request.fullpath
      end
  end

  def after_sign_in_path_for(resource)
    return session[:previous_url] if session[:previous_url] &&
             session[:previous_url] != '/visitors' &&
             !session[:previous_url].starts_with?('/users/auth/wordpress_hosted/callback?')
    root_path
  end
end
