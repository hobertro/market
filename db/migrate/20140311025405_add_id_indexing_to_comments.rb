class AddIdIndexingToComments < ActiveRecord::Migration
  def change
    add_index :comments, :user_id
    add_index :comments, :user_listing_id
  end
end
