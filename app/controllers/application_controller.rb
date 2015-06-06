class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :blocked_relationships?


  def blocked_relationships?
    id = params[:user_id] || params[:id]
    if all_blocked_users.include?(id.to_i)
      redirect_to root_path
    end
  end

  def all_blocked_users
    blocking_users = Relationship.get_blocking_users(current_user)
    blocked_users = Relationship.get_blocked_users(current_user)
    @blocked_users = blocked_users.concat(blocking_users).uniq
  end

  def any_users_that_block_current_user?
    Relationship.get_blocking_users(current_user)
  end

end
