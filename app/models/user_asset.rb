class UserAsset < ApplicationRecord
  belongs_to :user
  belongs_to :imageable, :polymorphic => true
  mount_uploader :path, AvatarUploader

end
