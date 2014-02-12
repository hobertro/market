class AddEquippedToUserItem < ActiveRecord::Migration
  def change
    add_column :user_items, :equipped, :string
  end
end
