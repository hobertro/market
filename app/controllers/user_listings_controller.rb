class UserListingsController < ApplicationController
    def index
        @items = []
        @items_hash = {}
        current_user.user_listings.each do |listing|
            listing.item_listings.each do |item_listing|
                @items.push(item_listing.item_id.to_s)
                @items_hash[item_listing.item_id.to_s] = item_listing.status
            end
        end
        @items_dict = Item.where(:id => @items).to_a
    end

    def new
        @user = current_user
    end

    def destroy

    end

    def show
        
    end

    def create
        @offered_items = JSON.parse(params[:offer])
        if current_user
            @user_listings = current_user.user_listings.create()
            @offered_items.each do |item|
              @user_listings.item_listings.create({"item_id" => item.to_i, "status" => "have"})
            end
        end
        render :text => @offered_items
    end

    private
    helper_method :SessionHelper
end
