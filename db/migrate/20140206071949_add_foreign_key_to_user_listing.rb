class AddForeignKeyToUserListing < ActiveRecord::Migration
  def change
    add_column :user_listings, :user_id, :integer
  end
end
