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

  before_save :create_remember_token

  has_many :user_items # foreign_key: "item_id"
  has_many :items, through: :user_items


  def self.get_user_items(steam_id)
    url = "http://api.steampowered.com/IEconItems_570/GetPlayerItems/v0001?SteamID=" + steam_id + "&key=" + ENV["STEAM_WEB_API_KEY"]
    parsed_data(url)  # reading HTTP request using open-uri
  end

=begin
  def old_create_player_items(steam_id)
    item_hash = User.get_user_items(steam_id)
    # defindex_ids = item_hash["result"]["items"].map { |item| item["defindex"]  } 
    item_hash["result"]["items"].each do |item|
      item_defindex = item["defindex"]
      #create array of item indexes
      item_from_db = Item.find_by_defindex(item_defindex)
      # eliminate N queries with 1 query
      # make a hash where all the keys are the def indexes, and values are the objects
      # convert defindex to a string, are originally numbers
      if item_defindex.to_s == item_from_db.defindex
          # create player items
          self.user_items.create(item_id: item_from_db.id)
      end
    end
    return "Done! :D"
  end
=end

  def create_player_items(steam_id)
    # steam_id = "76561198033544098"
    # get player items
    item_hash = User.get_user_items(steam_id)
    # create an array of the items based on defindex numbers
    defindex_ids = item_hash["result"]["items"].map { |item| item["defindex"]  }
    # find and create an array based on the defindexs in the Items table defindex 
    items = Item.where(:defindex => defindex_ids).to_a
    # items_dict = {}
    # items.each { |item| items_dict[item["defindex"].to_s] = item }
    items.each { |item| self.user_items.first_or_create(item_id: item.id) }
  end

  def self.from_omniauth(auth)
    @authorization = User.find_by_steam_id(auth["uid"])
      if @authorization
        return @authorization
      else
        self.create_from_omniauth(auth)
      end
  end

  def self.create_from_omniauth(auth)
    User.create!({"steam_id" => auth["uid"], "steam_name" => auth.info.name})
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
