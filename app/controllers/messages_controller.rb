class MessagesController < ApplicationController
    before_filter :signed_in_user, only: [:create, :new, :show, :index, :destroy]
    before_filter :correct_user, only: [:create, :new, :show, :index, :destroy]

    def index
        @user = User.find(params[:user_id])
        # @messages = Message.all
    end

    def new
        @user = User.find(params[:user_id])
        @recipient = User.find(params[:recipient])
        @message = @user.messages.new
    end

    def create
        @user = User.find(params[:user_id])
        @recipient = User.find(params[:recipient_id])
        @content = params[:message][:content]
        @new_message = @user.messages.new({content: @content, recipient_id: @recipient.id, messenger_id: @user.id})
        if @new_message.save
          flash[:notice] = "Message successfully sent"
          redirect_to user_messages_path(@user)
        else 
          flash[:alert] = "Message failed. Make sure you type a message! :D"
          redirect_to new_user_message_path(@user, {:recipient => @recipient})
        end
        
    end

    def show
        @user = User.find(params[:user_id])
        @message = Message.find(params[:id])
        @conversation = Message.where(["(messenger_id = ? AND recipient_id = ?) OR (messenger_id = ? AND recipient_id = ?)", 
                                @message.messenger_id, @message.recipient_id, @message.recipient_id, @message.messenger_id])
                                .order("created_at DESC")
    end

    def destroy
        @user = User.find(params[:user_id])
        @message = Message.find(params[:id])
        @message.destroy
        redirect_to user_messages_path(@user)
    end

    def sent_messages
        @user = User.find(params[:user_id])
    end

end
