class Group < ActiveRecord::Base
  validates :name, presence: true, allow_blank: false, 
             length: { maximum: 50 }
  has_many :memberships, dependent: :destroy
  has_many :users, :through => :memberships
  mount_uploader :picture, PictureUploader

  private
  # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end 
    end 
end
