class AddItemIdToUserListing < ActiveRecord::Migration
  def change
    add_column :user_listings, :item_id, :integer
  end
end
