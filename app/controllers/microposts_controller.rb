class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  # /microposts
  def create
  end

  # /microposts/1
  def destroy
  end

end
