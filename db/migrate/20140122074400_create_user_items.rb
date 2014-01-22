class CreateUserItems < ActiveRecord::Migration
  def change
    create_table :user_items do |t|
      t.integer :user_id
      t.integer :item_id

      t.timestamps
    end
  end
end
