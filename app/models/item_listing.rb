class ItemListing < ActiveRecord::Base

  attr_accessible :user_listing_id, :item_id, :status

  belongs_to :user_listing, inverse_of: :item_listings
  belongs_to :item

  validates_inclusion_of :status, :in => ['offered', 'wanted'], :message => "must either be offered or wanted"
  validates_presence_of  :user_listing, :message => "user_listings are not present"
  validates_presence_of  :status, :message => "status not present"

end
