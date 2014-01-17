class AddMoreAttributesToItems < ActiveRecord::Migration
  def change
    add_column :items, :item_slot, :string
    add_column :items, :drop_type, :string
    add_column :items, :item_set, :string
    add_column :items, :holiday_restrictions, :string
    add_column :items, :model_player, :string
    add_column :items, :craft_class, :string
    add_column :items, :craft_material_type, :string
    add_column :items, :attributes, :string
    add_column :items, :tool, :string
    add_column :items, :used_by_classes, :string
    add_column :items, :per_class_loadout_slots, :string
    add_column :items, :styles, :string
  end
end
