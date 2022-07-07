class SessionsController < ApplicationController
  def new
  end

  def create
    # Find the user based on their email provided in the login form
    user = User.find_by(email: params[:session][:email].downcase)

    # if user exists and the password is correct
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      redirect_to user
    else
      # Create an error message.
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new', status: :unprocessable_entity
      # redirect_to login_url
    end


  end

  def destroy
  end
end
