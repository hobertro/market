class UserItem < ActiveRecord::Base
  attr_accessible :item_id, :user_id, :equipped, :quality

  belongs_to :user 
  belongs_to :item
  
end