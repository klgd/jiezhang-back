class BgAvatar < UserAsset
  belongs_to :user
  belongs_to :asset
  has_many :user_assest, as: :imageable

end