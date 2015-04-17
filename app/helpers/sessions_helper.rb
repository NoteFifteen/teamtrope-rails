module SessionsHelper

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to user_omniauth_authorize_path(:wordpress_hosted)
    end
  end

  def current_user?(user)
    user == current_user
  end
end
