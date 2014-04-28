class StaticPagesController < ApplicationController
  def home
    # @listings = UserListing.all
    @listings = UserListing.paginate(:page => params[:page]).per_page(10)
  end

  def about
  end

  def faq
    # @user = User.find(params[:user_id])
    @user = User.find(13)
    @listings = @user.user_listings
  end

  def contact
  end

  def search
  end
end