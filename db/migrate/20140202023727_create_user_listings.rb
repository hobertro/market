class CreateUserListings < ActiveRecord::Migration
  def change
    create_table :user_listings do |t|
      t.string :item_want
      t.string :item_have

      t.timestamps
    end
  end
end
