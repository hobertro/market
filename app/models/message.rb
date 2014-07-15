class Message < ActiveRecord::Base
  attr_accessible :content, :messenger_id, :recipient_id
  before_create :set_default_status
  validates_length_of :content, :minimum => 1,
                                :wrong_length => "should be more than one {{count}} character"


    belongs_to :messenger, 
               class_name: "User",
               foreign_key: "messenger_id"


    belongs_to :recipient, 
                class_name: "User",
                foreign_key: "recipient_id"

    scope :unread, lambda { |user| where("status = ? AND recipient_id = ?", "unread", user)}

    def set_status_to_read
      self.status = "read"
      self.save
    end

    def self.unread_msg_count(user)
      self.unread(user).count
    end

    private

    def set_default_status
      self.status = "unread"
    end
end
