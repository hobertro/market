class Conversation

  attr_accessor :messenger
  attr_accessor :recipient

  def initialize(args)
    @messenger = args[:messenger]
    @recipient = args[:recipient]
  end

  # get all messages between messenger and recipient
  def get_conversation
    Message.where(["(messenger_id = ? AND recipient_id = ?) OR (messenger_id = ? AND recipient_id = ?)", 
                                messenger.id, recipient.id, recipient.id, messenger.id])
                                .order("created_at DESC")
  end

end