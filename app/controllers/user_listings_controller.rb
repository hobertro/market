class UserListingsController < ApplicationController
    before_filter :signed_in_user, only: [:create, :destroy]
    before_filter :correct_user, only: [:create, :destroy]


    def index
       @user = User.find(params[:user_id])
       @user_listings = @user.user_listings
    end

    def new
        @user = User.find(params[:user_id])
        @user_items = @user.user_items
        @user_listing = UserListing.new()
    end

    def destroy
        
    end

    def show
        @user = User.find(params[:user_id]) #probably need to eventually delete
        @listings = UserListing.find(params[:id])
        # @comments = @listings.comments.build()
    end

    ################ Have to create method to create listings on the model

    def create
        @user = User.find(params[:user_id])
        @offered_items = JSON.parse(params[:offer])
        @wanted_items = JSON.parse(params[:wanted])
        if @user
            @user_listings = @user.user_listings.create()
            @offered_items.each do |item|
              @user_listings.item_listings.create({"item_id" => item.to_i, "status" => "offered"})
            end
            @wanted_items.each do |item|
              @user_listings.item_listings.create({"item_id" => item.to_i, "status" => "wanted"})
            end
        end
        redirect_to root_path
    end

    def search
        search_params = params[:search]
        puts search_params
        if search_params
           item_results = Item.where('name LIKE ?', "%#{search_params}%")
        else
            render :user_path
        end
        render :json => item_results
    end

    def reload
        @user = current_user
        reloaded_items = @user.reload_player_items
        render :json => reloaded_items
    end

    private
    helper_method :SessionHelper
end
