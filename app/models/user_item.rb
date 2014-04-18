class UserItem < ActiveRecord::Base
  attr_accessible :item_id, :user_id, :equipped, :quality, :name, :defindex, 
                  :image_url, :item_description, :item_set, :rarity

  belongs_to :user 
  belongs_to :item
  
end