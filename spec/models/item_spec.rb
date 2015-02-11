require "rails_helper"

describe "Item" do
  context "validations" do 
    let (:item) { Item.new() }

    it "has many user_listings" do
      expect(item).to have_many(:user_listings)
    end

    it "has many user_items" do
      expect(item).to have_many(:user_items)
    end

    it "has many item_listings" do
      expect(item).to have_many(:item_listings)
    end

    it "has many user_items" do
      expect(item).to have_many(:users)
    end
  end
end