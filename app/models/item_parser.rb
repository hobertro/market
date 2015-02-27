# encoding: utf-8

require 'open-uri'
require 'json'
require 'awesome_print'

class ItemParser
  extend GetData

  def self.get_item_schema_url
    url = "http://api.steampowered.com/IEconItems_570/GetSchemaURL/v1?key=55BA1C088556CDF59A3B43120193700F"
    parsed_data(url)["result"]["items_game_url"]
  end

  def self.download_schema_url(url)
    open('item.txt', 'wb') do |file|
      file << open("#{url}").read
    end
  end

  def self.vdf_to_json
    puts "starting.."
    File.open('item.txt') do |file|
      output = File.open("output.rb", "w")
      parser = VDF4R::Parser.new(file)
      output << parser.parse
      output.close
    end
    puts "done!"
  end

  def self.get_schema
    parsed_data(get_schema_url)
  end

  def self.convert_json_to_ruby_hash
    file = File.read("./data/output.json")
    JSON.parse(file) 
  end

  def self.update_database
    # items = Item.where(:defindex => defindex_ids).to_a 
    items = ItemParser.convert_json_to_ruby_hash
    items["items_game"]["items"].each do |item|
      if db_item = Item.find_by_defindex(item[0].to_i)
        db_item.rarity = item[1]["item_rarity"]
        puts "found"
      else
        puts "not found"
        Item.create! do |new_item|
          new_item.name =     item[1]["name"]
          new_item.defindex = item[0]
          new_item.rarity =   item[1]["item_rarity"]
        end
      end
    end
    puts "hihi"
  end
end