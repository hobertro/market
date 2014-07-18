class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :status
      t.integer :user_id
      t.integer :other_user_id

      t.timestamps
    end
  end
end
