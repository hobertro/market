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
  attr_accessible :steam_id, :steam_name, :profile_url, :community_visibility, :profile_state,
  :last_logoff, :avatar, :avatar_medium, :avatar_full, :primary_clanid, :time_created, :person_state, :received_messages

  before_save :create_remember_token

  has_many :user_items, dependent: :destroy # foreign_key: "item_id",
  has_many :items, through: :user_items

  has_many :user_listings

  has_many :comments

  has_many :messages, 
           foreign_key: "messenger_id"
  has_many :received_messages, 
           class_name: "Message",
           foreign_key: "recipient_id"


  def reload_player_items    
    self.user_items.delete_all
    create_player_items(self.steam_id)
  end

  def self.get_user_items(steam_id)
    url = "http://api.steampowered.com/IEconItems_570/GetPlayerItems/v0001?SteamID=" + steam_id + "&key=" + ENV["STEAM_WEB_API_KEY"]
    parsed_data(url)  # reading HTTP request using open-uri
  end

  def create_player_items(steam_id)
    # get player items
    player_item_hash = User.get_user_items(steam_id)["result"]["items"]
    # create an array of the items based on defindex numbers
    defindex_ids = player_item_hash.map { |item| item["defindex"].to_i  }
    # find and create an array based on the defindexs in the Items table defindex 
    items = Item.where(:defindex => defindex_ids).to_a
    #items_dict = {}
    #items.each { |item| items_dict[item["defindex"].to_s] = item }
    items.each do |item|
      player_item_hash.each do |hash_item|
        if hash_item["defindex"].to_s == item.defindex
        self.user_items.create(item_id: item.id, equipped: hash_item["equipped"],
          quality: hash_item["quality"], rarity: item.rarity)
        end
      end
    end
    add_attr_to_items
    self.user_items
  end

  def find_rarity

  end

  def add_attr_to_items
    self.user_items.each do |user_item|
      user_item[:name] = user_item.item.name
      user_item[:defindex] = user_item.item.defindex
      user_item[:image_url] = user_item.item.image_url
      user_item[:item_description] = user_item.item.item_description
      user_item[:item_set] = user_item.item.item_set
      user_item.save
    end
  end

  def self.from_omniauth(auth)
    authorization = User.find_by_steam_id(auth["uid"])
      if authorization
           authorization
      else
        self.create_from_omniauth(auth)
      end
  end

  def self.create_from_omniauth(auth)
    info = auth["extra"]["raw_info"]
    User.create!({"steam_id" => info["steamid"], "steam_name" => info["personaname"],
      "community_visibility" => info["communityvisibilitystate"], "profile_state" =>
      info["profilestate"], "last_logoff" => info["lastlogoff"], "profile_url" => 
      info["profileurl"], "avatar" => info["avatar"],"avatar_medium" => info["avatarmedium"], 
      "avatar_full" => info["avatarfull"], "primary_clanid" => info["primaryclanid"], 
      "time_created" => info["timecreated"], "person_state" => info["personastate"]})
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
