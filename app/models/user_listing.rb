class UserListing < ActiveRecord::Base

  belongs_to :user
  has_many :item_listings,  inverse_of: :user_listing, dependent: :destroy
  has_many :items, through: :item_listings
  has_many :items_wanted,
           :through => :item_listings,
           :source => :item,
           :conditions => ["status = ?", "wanted"]
  has_many :items_offered,
           :through => :item_listings,
           :source => :item,
           :conditions => ["status = ?",  "offered"]

  has_many :comments, dependent: :destroy


  attr_accessible :status, :item_id, :comments

  accepts_nested_attributes_for :comments

  validates_presence_of :item_listings#, :message => "Item Listings are not present for some reason."
  validates_associated  :item_listings#, :message => "Something went wrong with associated listing items."
  validate :has_items
  validate :has_at_least_one_wanted_listing_item#, :message => "Requires one wanted item_listing"
  validate :has_at_least_one_offered_listing_item#, :message => "Requires one offered item_listing"
  validate :has_at_least_one_of_both_wanted_and_offered_item
  validates_length_of   :item_listings, :minimum => 2#, 
                                        #:message => "There needs to be at least one item listing with a status of 'wanted' and 'offered"

  private 

  def has_items
    errors.add(:base, 'must add at least one listing item') if self.item_listings.blank?
  end

  def has_at_least_one_wanted_listing_item
    errors.add(:base, "test1 failed") unless self.item_listings.any? {|item| item.status == "wanted" }
  end

  def has_at_least_one_offered_listing_item
    errors.add(:base, "test2 failed") unless self.item_listings.any? {|item| item.status == "offered"}
  end

  def has_at_least_one_of_both_wanted_and_offered_item
    errors.add(:base, "test3 failed") unless (self.item_listings.any? {|item| item.status == "wanted" }) && (self.item_listings.any? {|item| item.status == "offered"})
  end

  
end