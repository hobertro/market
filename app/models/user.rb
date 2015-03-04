require 'get_data'

class User < ActiveRecord::Base
  extend GetData 
  attr_accessible :steam_id, :steam_name, :profile_url, :community_visibility, 
  :profile_state, :last_logoff, :avatar, :avatar_medium, :avatar_full, 
  :primary_clanid, :time_created, :person_state, :received_messages, :other_user_id,
  :trade_url

  before_save :create_remember_token

  has_many :user_items, dependent: :destroy
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

  validates :steam_id, presence: true
  validates :steam_name, presence: true
  validates :avatar, presence: true
  validates :avatar_medium, presence: true
  validates :avatar_full, presence: true

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

  ## start testing here

  def has_items?
    !user_items.empty?
  end

  ## need to work on reload_player_items

  def reload_player_items
    user_items.delete_all
    create_player_items
  end

  ## need to fix rescue, can't rescue all errors

  def get_user_items(steam_id)
    url = "http://api.steampowered.com/IEconItems_570/GetPlayerItems/v0001?SteamID=" + steam_id + "&key=" + ENV["STEAM_WEB_API_KEY"]
    User.parsed_data(url)  # reading HTTP request using open-uri, returns a hash that is a parsed JSON object
  end

  def create_player_items
    merge_items.each do |item|
      user_items.create!(item)
    end
  end

  def merge_items
    merged_items_array = []
    items = Item.where(:defindex => defindex_ids).to_a
    player_item_hash.each do |i|
      items.each do |item|
        if i["defindex"].to_s == item.defindex
          array_with_attributes = {}
          array_with_attributes["item_id"]          = item.id
          array_with_attributes["equipped"]         = i["equipped"]
          array_with_attributes["quality"]          = i["quality"]
          array_with_attributes["rarity"]           = item.rarity
          array_with_attributes["name"]             = item.name
          array_with_attributes["defindex"]         = i["defindex"]
          array_with_attributes["image_url"]        = item.image_url
          array_with_attributes["item_description"] = item.item_description
          array_with_attributes["item_set"]         = item.item_set
          merged_items_array.push(array_with_attributes)
        end
      end
    end
    return merged_items_array
  end

  def self.hi
    puts "hihi"
  end

  private

  def player_item_hash
    @player_item_hash ||= get_user_items(steam_id)["result"]["items"]
  end

  def defindex_ids
    player_item_hash.map { |item| item["defindex"].to_s }
  end

  def self.from_omniauth(auth)
    # find a user by their UID (assigned by Steam) by using ActiveRecord dynamic finder
    auth_user = self.find_by(steam_id: auth["uid"])
    ## create player in db unless they exist already
    if auth_user
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

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
