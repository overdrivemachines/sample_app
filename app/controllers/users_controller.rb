class UsersController < ApplicationController
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
end
