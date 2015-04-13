module SessionsHelper

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to new_user_session_path, notice: "Please sign in."
    end
  end

  def current_user?(user)
    user == current_user
  end
end
