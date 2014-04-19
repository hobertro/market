class ChangeStringtoTextItems < ActiveRecord::Migration
  def up
    change_column :items, :item_description, :text
    change_column :items, :image_url, :text
    change_column :items, :image_url_large, :text
    change_column :items, :capabilities, :text
    change_column :items, :tool, :text
    change_column :items, :image_inventory, :text
  end

  def down
    change_column :items, :item_description, :string
    change_column :items, :image_url, :string
    change_column :items, :image_url_large, :string
    change_column :items, :capabilities, :string
    change_column :items, :tool, :string
    change_column :items, :image_inventory, :string
  end
end
