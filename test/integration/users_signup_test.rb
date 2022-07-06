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
  end

end
