class StaticPagesController < ApplicationController
  skip_before_filter :blocked_relationships?
  
  def home
    # create a method that gets all listings except hte listings of blocked users
    if signed_in?
      if Relationship.get_all_block_or_blocking_users(current_user.id).present?
        all_blocked_users = Relationship.get_all_block_or_blocking_users(current_user.id)
        blocked_user_listings = UserListing.where("user_id NOT IN (?)", all_blocked_users)
        @user_listings = blocked_user_listings.paginate(:page => params[:page]).per_page(10)
      else
        @user_listings = UserListing.paginate(:page => params[:page]).per_page(10)
      end
    end
  end

  def about
  end

  def faq
  end

  def contact
  end

  def search
  end
end
