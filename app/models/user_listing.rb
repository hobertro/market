class UserListing < ActiveRecord::Base

  belongs_to :user
  belongs_to :item

  has_many :item_listings, dependent: :destroy
  has_many :items, through: :item_listings
  
  attr_accessible :status, :item_id
end
