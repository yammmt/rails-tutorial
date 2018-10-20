class Micropost < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  mount_uploader :picture, PictureUploader

  private

    # check uploaded picture size
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
