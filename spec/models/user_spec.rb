require "rails_helper"

describe User do

  context "attributes" do
    it "has a steam_id" do 
      User.new.should respond_to :steam_id
    end

    it "has a steam_name" do 
      User.new.should respond_to :steam_name
    end

    it "has a collection of listings" do 
      User.new.user_listings.should be_kind_of Array
    end
  end

  context "methods" do

    describe "#has_items?" do 
      user = User.create()

      context "User has no items" do
        it "#has_items? returns true if player has no items" do
          user.user_items.create()  
          expect(user.has_items?).to eq(true)
        end
      end

      context "User has items" do
        it "#has_items? returns false if player has no items" do
          expect(user.has_items?).to eq(false)
        end
      end
    end

    describe "#get_user_items" do
      it "returns a user's items from Steam web api"
    end
  end


end