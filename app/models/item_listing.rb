class ItemListing < ActiveRecord::Base

  attr_accessible :user_listing_id, :item_id, :status

  belongs_to :user_listing
  belongs_to :item


end
