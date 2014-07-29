class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :blocked_relationships?

  def blocked_relationships?
    puts params[:id]
    puts "hihi"
    puts params[:user_id]
    id = params[:id] || params[:user_id]
    user = User.find(id)
    if User.is_relationship_blocked?(user, current_user)
      redirect_to root_path
    end
  end
end
