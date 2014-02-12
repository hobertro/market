class AddUserListingIdandItemIdtoItemListing < ActiveRecord::Migration
  def change
    add_column :item_listings, :user_listing_id, :integer
    add_column :item_listings, :item_id, :integer
  end
end
