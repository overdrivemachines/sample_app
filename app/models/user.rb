class User < ApplicationRecord
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
end
