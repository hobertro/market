class UserListingsController < ApplicationController
    before_filter :signed_in_user, only: [:create, :destroy, :new]
    before_filter :correct_user, only: [:create, :destroy, :new]

    def index
       @user = User.find(params[:user_id])
       @user_listings = @user.user_listings
    end

    def new
        @user = User.find(params[:user_id])
        @user_items = @user.user_items
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
    end

    ################ Have to create method to create listings on the model

    def create
        @user = User.find(params[:user_id])
        @offered_items = JSON.parse(params[:offer])
        @wanted_items = JSON.parse(params[:wanted])
        @notes = params[:listnote]
        if @user
            @user_listings = @user.user_listings.create()
            @offered_items.each do |item|
              @user_listings.item_listings.create({"item_id" => item.to_i, "status" => "offered"})
            end
            @wanted_items.each do |item|
              @user_listings.item_listings.create({"item_id" => item.to_i, "status" => "wanted"})
            end
        end
        comment = @user_listings.comments.build({"user_listing_id" => @user_listings.id, "user_id" => @user.id, "description" => @notes}) #might be violating Rails Way here
        if @user_listings.save
          flash[:success] = "Your listing has been successfully created!!"
          redirect_to([@user, @user_listings])
        else
          flash[:notice] = "Oh no! Something went wrong, try again!"
          redirect_to user_user_listings_path(@user)
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

    def reload
        @user = current_user
        reloaded_items = @user.reload_player_items
        render :json => reloaded_items
    end

    private
    helper_method :SessionHelper
end
