class SessionsController < ApplicationController
  def new
  end

  def create
    # Find the user based on their email provided in the login form
    user = User.find_by(email: params[:session][:email].downcase)

    # if user exists and the password is correct
    # if user&.authenticate(params[:session][:password])
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      # Reset Session to prevent Session Fixation
      reset_session
      # temporary cookie containing user's id
      # log_in() is defined in sessions_helper.rb
      log_in user
      redirect_to user
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
      # redirect_to login_url
    end


  end

  def destroy
    # Call the log_out method which is defined in sessions_helper.rb
    log_out
    # When using Turbo, this ':see_other' status code (corresponding to the
    # HTTP status code 303 See Other) is necessary to ensure the correct
    # behavior when redirecting after a DELETE request
    redirect_to root_url, status: :see_other
  end
end
