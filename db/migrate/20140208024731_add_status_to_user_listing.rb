class AddStatusToUserListing < ActiveRecord::Migration
  def change
    add_column :user_listings, :status, :string
  end
end
