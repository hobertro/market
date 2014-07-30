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

class User < ActiveRecord::Base
  extend GetData 
  attr_accessible :steam_id, :steam_name, :profile_url, :community_visibility, 
  :profile_state, :last_logoff, :avatar, :avatar_medium, :avatar_full, 
  :primary_clanid, :time_created, :person_state, :received_messages, :other_user_id,
  :trade_url

  before_save :create_remember_token

  has_many :user_items, dependent: :destroy # foreign_key: "item_id",
  has_many :items, through: :user_items

  has_many :user_listings, dependent: :destroy

  has_many :comments, dependent: :destroy

  has_many :messages, 
           foreign_key: "messenger_id",
           dependent: :destroy
  has_many :received_messages, 
           class_name: "Message",
           foreign_key: "recipient_id"
  has_many :relationships, dependent: :destroy
  has_many :other_users,  :through => :relationships,
                          :source  => :other_user

  ## validate trade_url

  def blocked_relationships(user_id, other_user_id)
    Relationship.blocked_relationships(user_id, other_user_id)
  end

  def blocked_users
    other_users.where("status = ?", "blocked")
  end

  def self.is_relationship_blocked?(user, other_user)
    Relationship.is_blocked_relationship?(user, other_user)
  end
                          

  def reload_player_items
    self.user_items.delete_all
    create_player_items(self.steam_id)
  end

  def have_items?
    create_player_items(steam_id) if self.user_items.empty?
  end

   #possible violation of SRP with method below

  def self.get_user_items(steam_id)
    url = "http://api.steampowered.com/IEconItems_570/GetPlayerItems/v0001?SteamID=" + steam_id + "&key=" + ENV["STEAM_WEB_API_KEY"]
    begin
      parsed_data(url)  # reading HTTP request using open-uri
    rescue
      return "hihi"
    end
  end

  def create_player_items(steam_id)
    # get player items
    begin
        self.user_items.delete_all
        player_item_hash = User.get_user_items(steam_id)["result"]["items"]
    rescue
      return "hihi"
    end
        # create an array of the items based on defindex numbers
        defindex_ids = player_item_hash.map { |item| item["defindex"].to_s }
        # find and create an array based on the defindexs in the Items table defindex 
        items = Item.where(:defindex => defindex_ids).to_a
        items.each do |item|
          player_item_hash.each do |hash_item|
            if hash_item["defindex"].to_s == item.defindex
              #self.user_items.create(item_id: item.id, equipped: hash_item["equipped"],
              #quality: hash_item["quality"], rarity: item.rarity)
              self.user_items.create! do |ui| #ui = user item
                ui.item_id          = item.id
                ui.equipped         = hash_item["equipped"]
                ui.quality          = hash_item["quality"]
                ui.rarity           = item.rarity
                ui.name             = item.name
                ui.defindex         = item.defindex
                ui.image_url        = item.image_url
                ui.item_description = item.item_description
                ui.item_set         = item.item_set
              end
            end
          end
        end
        #add_attr_to_items
        #self.user_items
  end

=begin
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
=end

  ## need to refactor code below

  def self.from_omniauth(auth)
    if auth_user = self.find_by_steam_id(auth["uid"])
    ## create player in db unless they exist already
      return auth_user
    else 
      self.create_from_omniauth(auth)
    end
  end

  def self.create_from_omniauth(auth)
    info = auth["extra"]["raw_info"]
    User.create! do |u| 
      u.steam_id             = info["steamid"]
      u.steam_name           = info["personaname"]
      u.community_visibility = info["communityvisibilitystate"]
      u.profile_state        = info["profilestate"]
      u.last_logoff          = info["lastlogoff"]
      u.profile_url          = info["profileurl"]
      u.avatar               = info["avatar"]
      u.avatar_medium        = info["avatarmedium"]
      u.avatar_full          = info["avatarfull"]
      u.primary_clanid       = info["primaryclanid"]
      u.time_created         = info["timecreated"]
      u.person_state         = info["person_state"]
    end
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
