require "test_helper"

class UserTest < ActiveSupport::TestCase
  # Setup runs before each test
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  test "should be valid" do
    assert @user.valid?
  end

  # Presence
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  # Length
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # Format
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # Uniqueness
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  # Test for the email downcasing
  test "email addresses should be saved as lowercase" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # Password Presence
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # Password Length
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  # Test following? to make sure the user isn’t following the other user,
  # use follow to follow another user, use following? to verify that the
  # operation succeeded, and finally unfollow and verify that it worked.
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    # verify michael is not following archer
    assert_not michael.following?(archer)
    # michael follows archer
    michael.follow(archer)
    # verify micheal is following archer
    assert michael.following?(archer)
    # verify michael is one of archer's followers
    assert archer.followers.include?(michael)
    # make archer follow michael.
    # Archer is already following Michael as defined in relationships.yml
    # archer.follow(michael)
    # verify archer is following michael
    assert archer.following?(michael)
    # michael unfollows archer
    michael.unfollow(archer)
    # verify michael is not following archer
    assert_not michael.following?(archer)
    # Users can't follow themselves.
    michael.follow(michael)
    assert_not michael.following?(michael)
  end



  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Michael follows Lana but not Archer based on relationships.yml
    # Michael should see Lana’s posts and his own posts, but not Archer’s posts.

    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Self-posts for user with followers
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
      # assert_equal michael.feed.distinct, michael.feed
    end
    # Self-posts for user with no followers
    archer.microposts.each do |post_self|
      assert archer.feed.include?(post_self)
    end
    # Posts from non-followed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

end
