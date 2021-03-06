module SessionsHelper

  # log in with given params
  def log_in(user)
    session[:user_id] = user.id
  end

  # make user's session permanent
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # return true if user is logged in
  def current_user?(user)
    user == current_user
  end

  # return current logged in user (or nil)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # return true if user is logged in
  def logged_in?
    !current_user.nil?
  end

  # discard permanent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # log out current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # redirect to memoried URL (or default URL)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # memory URL user wanted to get
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
