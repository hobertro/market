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
      user = FactoryGirl.build(:user)
      expect(user).to be_valid
    end

    it "should be invalid without a steam_id" do
      user = FactoryGirl.build(:user, steam_id: nil)
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
      expect(User.new.user_listings).to be_kind_of Array
    end
  end

  context "methods" do

    let(:user) { User.new(valid_attributes) }

    describe "#remember_token" do 
      before { user.save }
      it "responds to #remember_token" do
        expect(user).to respond_to(:remember_token)
      end

      it "contains a remember_token after being created" do
        expect(user.remember_token).to_not be_blank
      end
    end

    describe "#has_items?" do 
      context "User does not have any items" do
        before { user.save() }
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
      it "returns a user's items from Steam web api" do
        stub_request(:get, "http://api.steampowered.com/IEconItems_570/GetPlayerItems/v0001?SteamID=12345&key=55BA1C088556CDF59A3B43120193700F").
         with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, body: [valid_attributes.to_json], :headers => {})
         expect(user.get_user_items).to eq([valid_attributes.to_json])
      end
    end

    context "related to using Steam API for PLAYER ITEMS" do 
      before(:each) do
        stub_request(:get, "http://api.steampowered.com/IEconItems_570/GetPlayerItems/v0001?SteamID=12345&key=55BA1C088556CDF59A3B43120193700F").
           with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
           to_return(:status => 200, body: [valid_attributes.to_json], :headers => {})
      end

      describe "#merge_items" do
        it "returns an array with merged attributes"
      end

      describe "#create_player_items" do
        it "creates user_items based on how many items there are in #merge_items"
      end
    end


  end


end