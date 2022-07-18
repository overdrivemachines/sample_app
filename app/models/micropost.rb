class Micropost < ApplicationRecord
  belongs_to :user
  # descending order from newest to oldest.
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
