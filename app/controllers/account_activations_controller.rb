class AccountActivationsController < ApplicationController
  # Edit action gets called when user clicks on activation link in email
  # e.g. link: http://localhost:3000/account_activations/ChCkiCMDIodAi6uG8-aYEw/edit?email=c%40c.com
  def edit
    user = User.find_by(email: params[:email])
    activation_token = params[:id]

    # If: 1) user exists 2) user is activated and 3) user can be authenticated with the
    # given activation token, then activate and log in the user
    if user && !user.activated? && user.authenticated?(:activation, activation_token)
      # Activate User
      user.activate

      # Login User
      # reset_session
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
