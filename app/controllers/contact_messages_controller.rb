class ContactMessagesController < ApplicationController
  def create
    @name = params[:name]
    @email = params[:email]
    @subject = params[:subject]
    @content = params[:content]
    ContactMailer.welcome_email(@name, @email, @subject, @content).deliver
    flash[:success] = "Your message was sent! Thank you for contacting us!"
    redirect_to new_contact_message_path
  end

  def new
  end
end
