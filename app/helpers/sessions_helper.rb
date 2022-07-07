module SessionsHelper
  def log_in(user)
    # Section 8.2.1
    # Places a temporary cookie on the user’s browser
    # containing an encrypted version of the user’s id.
    # Expires immediately when the browser is closed.
    session[:user_id] = user.id
  end


  # Returns the current logged-in user (if any).
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
end
