class UserAsset < ApplicationRecord
  belongs_to :user
  mount_uploader :path, AvatarUploader

end