class UserListingsController < ApplicationController

    before_filter :signed_in_user, only: [:create, :destroy, :new]
    before_filter :correct_user, only: [:create, :destroy, :new]
    skip_before_filter :blocked_relationships?, only: [:search, :reload]

    def index
       @user = User.find(params[:user_id])
       @user_listings = @user.user_listings
    end

    def new
        @user = User.find(params[:user_id])
        @user_items = @user.items
        @user_listing = UserListing.new()
        @comment = @user_listing.comments.new()
    end

    def destroy
        @user = User.find(params[:user_id])
        @user_listing = UserListing.find(params[:id])
        if @user_listing.destroy
            flash[:success] = "Your listing has been successfully deleted"
        else
            flash[:alert] = "Something went wrong!"
        end
        redirect_to url_for([@user, @user_listing])
    end

    def show
        @user = User.find(params[:user_id]) #probably need to eventually delete
        @user_listing = UserListing.find(params[:id])
        @comments = @user_listing.comments
    end

    ################ Have to create method to create listings on the model

    def create
        offered_items = JSON.parse(params[:offer])
        wanted_items = JSON.parse(params[:wanted])
        notes = params[:listnote]
        user_listings = current_user.user_listings.new()

        offered_items.each do |item|
            original_item = Item.find_by_defindex(item)
            user_listings.item_listings.build({"item_id" => original_item.id, "status" =>"offered"})
        end

        wanted_items.each do |item|
            original_item = Item.find_by_defindex(item)
            user_listings.item_listings.build({"item_id" => original_item.id, "status" => "wanted"})
        end

        user_listings.comments.build({"user_listing_id" => user_listings.id, "user_id" => 
            current_user.id, "description" => notes})
        if user_listings.save
          flash[:success] = "Your listing has been successfully created!"
          redirect_to([current_user, user_listings])
        else
          puts user_listings.errors.inspect
          flash[:danger] = "Oh no! Something went wrong, try again!"
          redirect_to user_user_listings_path(current_user)
        end
    end


    def search
        search_params = params[:search]
        if search_params
           item_results = Item.where("LOWER(name) LIKE ?", "%#{search_params.downcase}%")
        else
            render :user_path
        end
        render :json => item_results
    end

    ## does this belong here? 3/18/15

    def reload
        current_user.reload_player_items
        render :json => current_user.user_items
    end

    private
    helper_method :SessionHelper
end
