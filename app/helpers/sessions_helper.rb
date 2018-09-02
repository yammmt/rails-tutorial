module SessionsHelper

  # log in with given params
  def log_in(user)
    session[:user_id] = user.id
  end

  # return current logged in user (or nil)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # return true if user is logged in
  def logged_in?
    !current_user.nil?
  end

  # log out current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
