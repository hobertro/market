class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :blocked_relationships?

  def blocked_relationships?
    id = params[:user_id] || params[:id]
    user = User.find(id)
    if user.other_users.include?(current_user)
      redirect_to root_path
    end
  end
end
