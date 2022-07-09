class User < ApplicationRecord
  attr_accessor :remember_token
  # Before saving to database, downcase email.
  # self keyword is optional on right hand side
  before_save {
    # self.email = email.downcase
    email.downcase!
  }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password

  # Returns the hash digest of the given string.
  # For use in the test fixtures
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
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
  end


  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forget a user. Sets the remember_digest attribute to nil
  def forget
    update_attribute(:remember_digest, nil)
  end
end
