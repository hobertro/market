# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  steam_name :string(255)
#  steam_id   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'get_data'
require 'awesome_print'

class User < ActiveRecord::Base
  extend GetData
  attr_accessible :steam_id, :steam_name
  has_many :user_items # foreign_key: "item_id"
  has_many :items, through: :user_items


  def self.get_user_items(steam_id)
    url = "http://api.steampowered.com/IEconItems_570/GetPlayerItems/v0001?SteamID=" + steam_id + "&key=" + ENV["STEAM_WEB_API_KEY"]
    parsed_data(url)  # reading HTTP request using open-uri
  end

  def test
    id = "76561198033544098"
    item_hash ||= User.get_user_items(id)
    item_hash["result"]["items"].each do |item|
    item_defindex = item["defindex"]
    item_from_db = Item.find_by_defindex(item_defindex)
    self.user_items.create
    # convert defindex to a string, are originally numbers
      if item_defindex.to_s == item_from_db.defindex
          # create player items
          self.user_items.create(item_id: item_from_db.id)
      end
    end
    return "Done! :D"
  end

  def create_player_items(steam_id)
    item_hash = User.get_user_items(steam_id)
    item_hash["result"]["items"].each do |item|
    item_defindex = item["defindex"]
    item_from_db = Item.find_by_defindex(item_defindex)
    self.user_items.create
    # convert defindex to a string, are originally numbers
      if item_defindex.to_s == item_from_db.defindex
          # create player items
          self.user_items.create(item_id: item_from_db.id)
      end
    end
    return "Done! :D"
  end

  def self.from_omniauth(auth)
    @authorization = User.find_by_steam_id(auth["uid"])
    if @authorization
       puts "We are in authorization"
        return @authorization
    else
        puts  "We are in else"
        self.create_from_omniauth(auth)
    end
  end

  def self.create_from_omniauth(auth)
    User.create!({"steam_id" => auth["uid"], "steam_name" => auth.info.name})
  end
end
