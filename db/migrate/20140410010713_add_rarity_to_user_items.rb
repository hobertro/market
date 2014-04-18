class AddRarityToUserItems < ActiveRecord::Migration
  def change
    add_column :user_items, :rarity, :string
  end
end
