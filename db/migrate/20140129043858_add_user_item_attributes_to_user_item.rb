class AddUserItemAttributesToUserItem < ActiveRecord::Migration
  def change
    add_column :user_items, :equipped_class, :integer
    add_column :user_items, :equipped_slot, :integer
    add_column :user_items, :quality, :integer
  end
end
