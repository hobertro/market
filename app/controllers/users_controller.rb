class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :blocked_relationships

  def index

  end

  def show
    @user = User.find(params[:id])
    @user_listings = @user.user_listings.paginate(:page => params[:page]).per_page(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.trade_url = params[:user][:trade_url]
    @user.save
    if @user.save
      flash[:success] = "Your trade_url has been updated"
    else
      flash[:error] = "Oops there was an error, try again"
    end
    sign_in @user
    redirect_to edit_user_path
  end
end
