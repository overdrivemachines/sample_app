class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if (@user)
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render "new", status: :unprocessable_entity
    end
  end

  # URL: http://localhost:3000/password_resets/3BdBrXeQZSWqcxHA/edit?email=foo%40bar.com
  # User enters new password
  def edit
  end

  def update
    if params[:user][:password].empty?
      # If user submits a blank password
      @user.errors.add(:password, "can't be empty")
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params)
      # If user password update is successful, log in the user
      # @user.reset_digest = nil
      # @user.reset_sent_at = nil
      @user.forget
      reset_session
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Before filters

  def get_user
    @user = User.find_by(email: params[:email].downcase)
  end

  # Confirms a valid user.
  def valid_user
    unless (@user &&
            @user.authenticated?(:reset, params[:id]) &&
            @user.activated?)
      redirect_to root_url
    end
  end

  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
    # unless (Time.zone.now - @user.reset_sent_at < 2.days)
    #   redirect_to root_url
    # end
  end
end
