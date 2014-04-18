class AddRarityToItems < ActiveRecord::Migration
  def change
    add_column :items, :rarity, :string
  end
end
