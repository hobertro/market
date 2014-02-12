class AddIndexUserToUserListing < ActiveRecord::Migration
  def change
    add_index :user_listings, [:user_id]
  end
end
