class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image # one image per micropost
  # descending order from newest to oldest.
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
