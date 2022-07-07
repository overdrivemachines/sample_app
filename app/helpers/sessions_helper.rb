module SessionsHelper
  def log_in(user)
    # Section 8.2.1
    # Places a temporary cookie on the user’s browser
    # containing an encrypted version of the user’s id.
    # Expires immediately when the browser is closed.
    session[:user_id] = user.id
  end
end
