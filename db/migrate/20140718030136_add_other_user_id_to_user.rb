class AddOtherUserIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :other_user_id, :integer
  end
end
