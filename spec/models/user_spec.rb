require "rails_helper"

describe User do

  valid_attributes = {
    steam_id: "12345",
    steam_name: "bob",
    avatar: "www.blah.com",
    avatar_medium: "avy_medium",
    avatar_full: "avy_full"
  }

  context "validations" do

    it "should be valid with a steam_id, steam_name, avatar, avatar_medium, and avatar_full" do
      user = User.new(valid_attributes)
      expect(user).to be_valid
    end

    it "should be invalid without a steam_id" do
      user = User.new(valid_attributes.merge({steam_id: ""}))
      user.valid?
      expect(user.errors[:steam_id]).to include("can't be blank")
    end

    it "should be invalid without a steam_name" do
      user = User.new(valid_attributes.merge({steam_name: ""}))
      user.valid?
      expect(user.errors[:steam_name]).to include("can't be blank")
    end

    it "should be invalid without a avatar url" do
      user = User.new(valid_attributes.merge({avatar: ""}))
      user.valid?
      expect(user.errors[:avatar]).to include("can't be blank")
    end

    it "should be invalid without a avatar_medium url" do
      user = User.new(valid_attributes.merge({avatar_medium: ""}))
      user.valid?
      expect(user.errors[:avatar_medium]).to include("can't be blank")
    end

    it "should be invalid without a avatar full url" do
      user = User.new(valid_attributes.merge({avatar_full: ""}))
      user.valid?
      expect(user.errors[:avatar_full]).to include("can't be blank")
    end

  end

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
      user = User.create(valid_attributes)

      context "User does not have any items" do
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

    it "does some web request" do
      stub = stub_request(:get, "www.example.com")
      expect(stub).to have_been_requested
    end
  end


end