class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :steam_name
      t.string :steam_id

      t.timestamps
    end
  end
end
