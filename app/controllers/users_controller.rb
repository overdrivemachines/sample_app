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
      puts "successfully saved"
    else
      # Status necessary.
      # It renders regular HTML when using Turbo according to Section 7.3.1
      render 'new', status: :unprocessable_entity
    end
  end

  private

  # returns a version of the params hash with only the permitted attributes
  # (while raising an error if the :user attribute is missing).
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
