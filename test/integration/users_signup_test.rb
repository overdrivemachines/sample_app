require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # verify that clicking the signup button results in not creating
  # a new user when the submitted information is invalid.
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'

    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end


  # When user submits valid information, confirm that a user was created
  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end

end
