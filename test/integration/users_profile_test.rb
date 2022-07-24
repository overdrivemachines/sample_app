require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper # for full_title helper

  # we visit the user profile page and check for the page title
  # and the user’s name, Gravatar, micropost count, and
  # paginated microposts.

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'

    # response.body contains the full HTML source of the page
    # (and not just the page’s body).
    # the number of microposts appears somewhere on the page
    assert_match @user.microposts.count.to_s, response.body

    assert_select 'div.stats', count: 1
    assert_select '#following', @user.following.count.to_s
    assert_select '#followers', @user.followers.count.to_s

    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

end
