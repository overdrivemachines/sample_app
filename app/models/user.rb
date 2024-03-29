class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  # Associations
  # ============
  # Prevent userless microposts from being stranded in the database
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # Callbacks
  # =========
  before_save :downcase_email
  before_create :create_activation_digest

  # Validations
  # ===========
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_secure_password

  # Returns the hash digest of the given string.
  # For use in the test fixtures
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token. 22 chars long.
  # Used in generating "remember me" token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    # Update remember_digest in the database.
    # update_attribute bypasses validations. We don't have user's password
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_digest || remember
  end


  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forget a user. Sets the remember_digest attribute to nil
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    # update_attribute(:activated,    true)
    # update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  # 12.6: "The password reset was sent earlier than two hours ago."
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
             .includes(:user, image_attachment: :blob)
    # part_of_feed = "relationships.follower_id = :id or microposts.user_id = :id"
    # Micropost.left_outer_joins(user: :followers)
    #          .where(part_of_feed, { id: id })
    #          .includes(:user, image_attachment: :blob)
  end


  # check if current user is following the other user
  def following?(other_user)
    self.following.include?(other_user)
  end

  # make current user follow other user
  def follow(other_user)
    # self.active_relationships.create(followed_id: user.id)
    self.following << other_user unless self == other_user
  end

  # make user unfollow other user
  def unfollow(other_user)
    self.following.delete(other_user)
  end


  private

  # Before saving to database, convert email to all lowercase
  def downcase_email
    # self keyword is optional on right hand side
    # self.email = email.downcase
    email.downcase!
  end

  # Create activation token and digest
  # Only called when a User is created
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
