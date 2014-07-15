class AddStatusToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :status, :string 
    add_index :messages, :status
  end
end
