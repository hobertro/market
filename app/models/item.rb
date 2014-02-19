require 'get_data'
require 'awesome_print'

class Item < ActiveRecord::Base
  extend GetData
  attr_accessible :capabilities, :defindex, :image_inventory, :image_url, 
  :image_url_large, :item_class, :item_description, :item_quality, 
  :item_type_name, :max_ilevel, :min_ilevel, :name, :tools, :proper_name, 
  :item_name, :attributes, :item_slot, :drop_type, :item_set, :model_player,
  :holiday_restrictions, :craft_class, :craft_material_type, :tool, 
  :used_by_classes, :per_class_loadout_slots, :styles
  

  has_many :user_items, foreign_key: "user_id"
  has_many :users, through: :user_items, source: :item

  has_many :user_listings
  has_many :users, through: :user_listings

  has_many :item_listings
  has_many :user_listings, through: :item_listings

  #possibly need to add more attributes: attributes

  private

  def self.get_dota_items
    url = "http://api.steampowered.com/IEconItems_570/GetSchema/v0001/?&key=" + ENV["STEAM_WEB_API_KEY"] + "&language=en"
    parsed_data(url)
  end

  def self.all_dota_items
    self.get_dota_items["result"]["items"]
  end

  def self.populate_database
    self.all_dota_items.each do |item|
      new_item = Item.new(item)
      new_item.save
    end
=begin ##### Note: Inefficient way of adding Items to the DB. 
      new_item = Item.new()
      new_item.capabilities = item["capabilities"]
      new_item.defindex = item["defindex"]
      new_item.image_inventory = item["image_inventory"]
      new_item.image_url = item["image_url"]
      new_item.image_url_large = item["image_url_large"]
      new_item.item_class = item["item_class"]
      new_item.item_description = item["item_description"]
      new_item.item_quality = item["item_quality"]
      new_item.item_type_name = item["item_type_name"]
      new_item.max_ilevel = item["max_ilevel"]
      new_item.min_ilevel = item["min_ilevel"]
      new_item.name = item["name"]
      new_item.tools = item["tools"]
      new_item.proper_name = item["proper_name"]
      new_item.item_name = item["item_name"]
      new_item.save
    end
=end
    return "done!"
  end
end
