class SessionsController < ApplicationController
  def new
  end

  # Called when login form is submitted
  def create
    # Find the user based on their email provided in the login form
    @user = User.find_by(email: params[:session][:email].downcase)

    # if user exists and the password is correct
    # if user&.authenticate(params[:session][:password])
    if @user && @user.authenticate(params[:session][:password])
      # User exists and the password provided is correct

      if @user.activated?
        # user is activated so we can log the user in and redirect
        forwarding_url = session[:forwarding_url]

        # Reset Session to prevent Session Fixation
        reset_session

        # check if remember me checkbox is set in the login form
        if params[:session][:remember_me] == '1'
          # remember method is defined in sessions_helper.rb. It calls
          # user.remember and saves permanent cookies for:
          # user_id (encrypted) and remember_token
          remember(@user)
        else
          forget(@user)
        end

        # temporary cookie containing user's id
        # log_in() is defined in sessions_helper.rb
        log_in @user

        # redirect the user back to where they were or
        # to the user's show page (eg: /users/1)
        redirect_to forwarding_url || @user
      else
        # user is not activated so we cannot log the user in
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
      # redirect_to login_url
    end


  end

  def destroy
    # Call the log_out method which is defined in sessions_helper.rb
    log_out if logged_in?
    # When using Turbo, this ':see_other' status code (corresponding to the
    # HTTP status code 303 See Other) is necessary to ensure the correct
    # behavior when redirecting after a DELETE request
    redirect_to root_url, status: :see_other
  end
end
