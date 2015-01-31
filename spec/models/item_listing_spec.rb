require "rails_helper"

describe ItemListing do

  context "associations" do
    let(:item) { item = Item.new() }
    let(:user_listing) { user_listing = UserListing.new() }
    let(:item_listing) { item_listing = ItemListing.new() }
    
    it "belongs to user_listing" do
      expect(item_listing).to belong_to(:user_listing)
    end 

    it "belongs to item" do
      expect(item_listing).to belong_to(:item)
    end
  end

  context "validations" do
    
    let(:user_listing) { user_listing = UserListing.create() }
    let(:item_listing) { item_listing = user_listing.item_listings.new() }
    
    it "validates_inclusion_of(:status)" do
      expect(item_listing).to validate_inclusion_of(:status).in_array(%w(wanted offered))
    end

    it "validates_presence_of status" do
      expect(item_listing).to validate_presence_of(:status)
    end

    it "validates_presence_of user_listing" do
      expect(item_listing).to validate_presence_of(:user_listing)
    end

    context "with valid attributes" do 

        it "is valid with with a status attribute set to either wanted" do
          item_listing.status = "wanted"
          item_listing.save
          expect(item_listing).to be_valid
        end

        it "is valid with with a status attribute set to either offered" do
          item_listing.status = "offered"
          item_listing.save
          expect(item_listing).to be_valid
        end

    end

    context "with invalid attributes" do 

        it "is not valid if status is nil" do
          item_listing.status = nil
          item_listing.save
          expect(item_listing).to_not be_valid
        end

        it "is not valid if status is not either 'offered' or 'wanted" do 
          item_listing.status = "hello moto"
          item_listing.save
          expect(item_listing).to_not be_valid
        end

        it "is not valid if user_listing_id is nil" do
          item_listing.user_listing_id = nil
          item_listing.save
          expect(item_listing).to_not be_valid
        end

    end

  end
end