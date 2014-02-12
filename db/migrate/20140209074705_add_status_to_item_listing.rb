class AddStatusToItemListing < ActiveRecord::Migration
  def change
    add_column :item_listings, :status, :string
  end
end
