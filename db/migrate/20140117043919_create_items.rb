class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :defindex
      t.string :item_class
      t.string :item_type_name
      t.string :item_description
      t.integer :item_quality
      t.string :image_inventory
      t.string :min_ilevel
      t.string :max_ilevel
      t.string :image_url
      t.string :image_url_large
      t.string :capabilities
      t.string :tools
      
      t.timestamps
    end
  end
end
