module MessagesHelper
  def unread_messages(user)
    Message.unread(user).count
  end

  
end
