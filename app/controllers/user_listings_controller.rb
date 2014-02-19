class UserListingsController < ApplicationController

    def index
       @user = current_user
       puts @user
       @user_listings = current_user.user_listings
       puts @user_listings
    end

    def new
        @user = current_user
    end

    def destroy

    end

    def show
        
    end

    ################ Have to create method to create listings on the model

    def create
        @offered_items = JSON.parse(params[:offer])
        @wanted_items = JSON.parse(params[:wanted])
        if current_user
            @user_listings = current_user.user_listings.create()
            @offered_items.each do |item|
              @user_listings.item_listings.create({"item_id" => item.to_i, "status" => "offered"})
            end
            @wanted_items.each do |item|
              @user_listings.item_listings.create({"item_id" => item.to_i, "status" => "wanted"})
            end
        end
        render :text => "The offered items hash is: #{@offered_items} while the wanted_items hash
        is #{@wanted_items}"
    end

    private
    helper_method :SessionHelper
end
