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

    scope :unread, ->(user) { where("status = ? AND recipient_id = ?", "unread", user) }

    def set_status_to_read
      self.status = "read"
      self.save
    end

    def self.unread_msg_count(user)
      self.unread(user).count
    end

    def set_default_status
      self.status = "unread"
    end

    def self.conversation(users)
      messenger = users[:messenger]
      recipient = users[:recipient]
      Message.where(["(messenger_id = ? AND recipient_id = ?) OR (messenger_id = ? AND recipient_id = ?)", 
                                messenger.id, recipient.id, recipient.id, messenger.id])
                                .order("created_at DESC")
    end
end
