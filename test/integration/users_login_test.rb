require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # We need to test the following:
  # Visit the login path.
  # Verify that the new sessions form renders properly.
  # Post to the sessions path with an invalid params hash.
  # Verify that the new sessions form returns the right status code and gets re-rendered.
  # Verify that a flash message appears.
  # Visit another page (such as the Home page).
  # Verify that the flash message doesn’t appear on the new page.

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end


  # Visit the login path.
  # Post valid information to the sessions path.
  # Verify that the login link disappears.
  # Verify that a logout link appears
  # Verify that a profile link appears.
  test "login with valid information" do
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
