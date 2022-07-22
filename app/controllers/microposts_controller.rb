class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  # /microposts
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  # /microposts/1
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # redirect back to the referring page because
    # users can delete a micropost either from the home page or
    # the user's profile page. If the referring url is nil,
    # redirect to root url
    redirect_back_or_to(root_url, status: :see_other)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  # checks that the current user actually has a micropost with the given id
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url, status: :see_other if @micropost.nil?
  end

end
