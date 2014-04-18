class ContactMessagesController < ApplicationController
  def create
    puts "hello"
    @name = params[:name]
    @email = params[:email]
    @subject = params[:subject]
    @content = params[:content]
    ContactMailer.welcome_email(@name, @email, @subject, @content).deliver
  end

  def new
    puts "hello"
    @name = params[:name]
    @email = params[:email]
    @subject = params[:subject]
    @content = params[:content]
    ContactMailer.welcome_email(@name, @email, @subject, @content).deliver
  end
end
