class CreateItemListings < ActiveRecord::Migration
  def change
    create_table :item_listings do |t|

      t.timestamps
    end
  end
end
