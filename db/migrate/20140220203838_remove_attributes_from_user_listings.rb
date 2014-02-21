class RemoveAttributesFromUserListings < ActiveRecord::Migration
  def up
    remove_column :user_listings, :name
    remove_column :user_listings, :defindex
    remove_column :user_listings, :image_url
    remove_column :user_listings, :item_description
    remove_column :user_listings, :item_set
  end

  def down
    add_column :user_listings, :item_set, :string
    add_column :user_listings, :item_description, :string
    add_column :user_listings, :image_url, :string
    add_column :user_listings, :defindex, :string
    add_column :user_listings, :name, :string
  end
end
