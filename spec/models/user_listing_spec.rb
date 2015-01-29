require "rails_helper"

describe UserListing do

  context "validations" do

      let(:user_listing) { user_listing = UserListing.new() }
     
      it "is valid with both offered items and wanted items" do
        user_listing.item_listings << user_listing.item_listings.build({status: "offered"})
        user_listing.item_listings << user_listing.item_listings.build({status: "wanted"})
        user_listing.item_listings.each {|x| puts x.inspect }    
        user_listing.save
        expect(user_listing).to be_valid
      end

      it "is not valid without listing items" do
        user_listing.save
        expect(user_listing).to_not be_valid
      end

      it "is not valid without a listing_item with status: 'offered'" do
        user_listing.item_listings << user_listing.item_listings.build({status: nil})
        user_listing.item_listings << user_listing.item_listings.build({status: "wanted"})
        expect(user_listing).to_not be_valid
      end

      it "is not valid without a listing_item with status: 'wanted'" do
        user_listing.item_listings << user_listing.item_listings.build({status: nil})
        user_listing.item_listings << user_listing.item_listings.build({status: "offered"})
        user_listing.save
        expect(user_listing).to_not be_valid
      end

      it "is not valid without at least one listing item with status: 'wanted' and one with 'offered'" do
        user_listing.item_listings << user_listing.item_listings.build({status: "hihi"})
        user_listing.item_listings << user_listing.item_listings.build({status: "random"})
        user_listing.save
        expect(user_listing).to_not be_valid
      end 
  end
end