class UsersController < ApplicationController

  before_filter :blocked_relationships

  def index
  end

  def show
    @user = User.find(params[:id])
    @user_listings = @user.user_listings.paginate(:page => params[:page]).per_page(10)
  end
end
