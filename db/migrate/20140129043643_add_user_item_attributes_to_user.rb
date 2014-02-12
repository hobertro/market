class AddUserItemAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :equipped_class, :integer
    add_column :users, :equipped_slot, :integer
    add_column :users, :quality, :integer
  end
end
