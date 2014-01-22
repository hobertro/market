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

  def self.get_user_items(steam_id)
    url = "http://api.steampowered.com/IEconItems_570/GetPlayerItems/v0001?SteamID=" + steam_id + "&key=" + ENV["STEAM_WEB_API_KEY"]
    parsed_data(url)  # reading HTTP request using open-uri
  end

  def self.test
    Item.find_by_defindex("5129").defindex
  end

  def self.translate_items
    id = "76561198033544098"
    item_hash ||= User.get_user_items(id)
    translated_hash = {}
    item_hash["result"]["items"].each do |item|
    item_defindex = item["defindex"]
    # convert defindex to a string, are originally numbers
      if item_defindex.to_s == Item.find_by_defindex(item_defindex).defindex
          # create player items
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
