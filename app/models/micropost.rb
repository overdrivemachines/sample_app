class Micropost < ApplicationRecord
  belongs_to :user

  # one image per micropost
  has_one_attached :image do |attachable|
    # attachable.class is ActiveStorage::Reflection::HasOneAttachedReflection
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  # descending order from newest to oldest.
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
end
