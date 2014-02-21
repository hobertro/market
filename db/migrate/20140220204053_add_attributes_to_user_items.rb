class AddAttributesToUserItems < ActiveRecord::Migration
  def change
    add_column :user_items, :name, :string
    add_column :user_items, :defindex, :string
    add_column :user_items, :image_url, :string
    add_column :user_items, :item_description, :string
    add_column :user_items, :item_set, :string
  end
end
