class Message < ActiveRecord::Base
  attr_accessible :content, :messenger_id, :recipient_id
  validates_length_of :content, :minimum => 1,
                                :wrong_length => "should be more than one {{count}} character"


    belongs_to :messenger, 
               class_name: "User",
               foreign_key: "messenger_id"


    belongs_to :recipient, 
                class_name: "User", 
                foreign_key: "recipient_id"
end
