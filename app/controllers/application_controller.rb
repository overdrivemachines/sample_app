class ApplicationController < ActionController::Base
  include SessionsHelper # Make SessionsHelper available in all controllers

  private

  # Confirms a User is logged in.
  # If user is not logged in, redirect them to the login page with a flash msg
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url, status: :see_other
    end
  end
end
