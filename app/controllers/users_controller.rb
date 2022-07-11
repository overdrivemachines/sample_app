class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      # log_in() is defined in sessions_helper.rb
      log_in @user
      # redirect the browser to show the user’s profile
      flash[:success] = "Welcome to Sample App!"
      redirect_to @user
    else
      # Status necessary.
      # It renders regular HTML when using Turbo according to Section 7.3.1
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile update"
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  # returns a version of the params hash with only the permitted attributes
  # (while raising an error if the :user attribute is missing).
  # Uses strong parameters to prevent mass assignment vulnerability
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters

  # Confirms a User is logged in.
  # If user is not logged in, redirect them to the login page with a flash msg
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url, status: :see_other
    end
  end

  # Confirms the correct user.
  # Redirect if the logged in user is editing the details of another user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end
end
