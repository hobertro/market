class AddAttributesToUserListings < ActiveRecord::Migration
  def change
    add_column :user_listings, :name, :string
    add_column :user_listings, :defindex, :string
    add_column :user_listings, :image_url, :string
    add_column :user_listings, :item_description, :string
    add_column :user_listings, :item_set, :string
  end
end
