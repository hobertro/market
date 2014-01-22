class AddIndexesToPlayerItems < ActiveRecord::Migration
  def change
    add_index :user_items, :user_id
    add_index :user_items, :item_id
  end
end
