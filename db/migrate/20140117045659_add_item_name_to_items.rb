class AddItemNameToItems < ActiveRecord::Migration
  def change
    add_column :items, :item_name, :string
    add_column :items, :proper_name, :string
  end
end
