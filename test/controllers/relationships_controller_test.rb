require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  # attempts to access actions in the Relationships controller
  # require a logged-in user (and thus get redirected to the login page),
  # while also not changing the Relationship count

  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end
