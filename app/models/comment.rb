class Comment < ActiveRecord::Base
  attr_accessible :user_id, :user_listing_id, :description
  validates_length_of :description, :minimum => 1,
                                    :wrong_length => "should be more than one {{count}} character"

  belongs_to :user
  belongs_to :user_listing
  
end
