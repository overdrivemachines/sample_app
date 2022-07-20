class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page:params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url

      # reset_session
      # log_in() is defined in sessions_helper.rb
      # log_in @user
      # redirect the browser to show the user’s profile
      # flash[:success] = "Welcome to Sample App!"
      # redirect_to @user
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  private

  # returns a version of the params hash with only the permitted attributes
  # (while raising an error if the :user attribute is missing).
  # Uses strong parameters to prevent mass assignment vulnerability
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters

  # Confirms the correct user.
  # Redirect if the logged in user is editing the details of another user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end

  # Confirms an admin user.
  # Redirect to root url if the user is not an admin
  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
