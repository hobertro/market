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
  

  has_many :user_items
  has_many :users, through: :user_items
  
  has_many :user_listings

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
    @dict = []
    Item.all.each do |item|
      @dict.push(item.defindex.to_i)
    end

    self.all_dota_items.each do |item|
      if @dict.include?(item["defindex"])
        puts item
        puts item["defindex"]
        puts "have item"
      else
        puts "don't have item"
        new_item = Item.new(item)
        new_item.save
      end
    end
    return "hello moto"
  end

  def self.item_checker(steam_item)
    @dict = []
    Item.all.each do |item|
      @dict.push(item.defindex.to_i)
    end
    # return @dict
  end

  def self.steam_id_count
    steam_items = []
    self.all_dota_items.each do |item|
      steam_items.push(item)
    end
    puts steam_items.count
    return puts steam_items.count
  end

  def self.create_hash
    item_hash = {}
    Item.all.each do |item|
      item_hash["#{item.defindex}"] = item.name
    end

    return item_hash
  end

  def self.open_json_file_first(file_name)
    file = JSON.parse(File.read(file_name))
    Item.all.each do |item|
      if file["items"].include?(item.defindex)
        item.rarity = file["items"][item.defindex]["item_rarity"]
        item.save
        puts item.rarity
      end
    end
    return "done"
  end

  def self.open_json_file(file_name)
    file = JSON.parse(File.read(file_name))
    Item.all.each do |item|
      if file.include?(item.defindex)
        puts "Hello this works"
        item.rarity = file[item.defindex]["item_rarity"]
        item.save
        puts item.rarity
      end
    end
    return "done"
  end
end
