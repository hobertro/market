require "rails_helper"

describe Relationship do

  context "associations" do
    it "belongs to user" do
      should belong_to(:user)
    end

    it "belongs to other user" do
      should belong_to(:other_user)
    end
  end


  context "attributes" do

    relationship = FactoryGirl.build(:relationship)
    
    it "responds to #status" do
      expect(relationship).to respond_to :status
    end

    it "responds to #user_id" do
      expect(relationship).to respond_to :user_id
    end

    it "responds to #other_user_id" do
      expect(relationship).to respond_to :other_user_id
    end
  end

  context "methods" do
    
  end
end