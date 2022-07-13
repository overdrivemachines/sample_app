module SessionsHelper
  def log_in(user)
    # Section 8.2.1
    # Places a temporary cookie on the user’s browser
    # containing an encrypted version of the user’s id.
    # Expires immediately when the browser is closed.
    session[:user_id] = user.id

    # Guard against session replay attacks.
    # See https://bit.ly/33UvK0w for more.
    session[:session_token] = user.session_token
  end

  def remember(user)
    # generate remember_token and remember_digest and save them in cookies
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end


  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif (user_id = User.find_by(id: cookies.encrypted[:user_id]))
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user && user == current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    # Sets the remember_digest attribute to nil in the DB
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  # Stores the URL trying to be accessed to sessions.
  # GET requests only
  def store_location
    if request.get?
      session[:forwarding_url] = request.original_url
    end
  end
end
