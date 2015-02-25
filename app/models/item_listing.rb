class ItemListing < ActiveRecord::Base

  attr_accessible :user_listing_id, :item_id, :status

  belongs_to :user_listing, inverse_of: :item_listings
  belongs_to :item

  validates_presence_of  :user_listing #, :message => "can't be blank"
  validates_presence_of  :status #, :message => "can't be blank"
  validates_inclusion_of :status, :in => ['offered', 'wanted']# , :message => "must either be offered or wanted"

end
