require "rails_helper"

describe Relationship do

  context "validations" do

  end

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
    it "responds to status" do
      relationship = create(:relationship)
      expect(relationship).to respond_to(:status)
    end

    context "create_blocked_relationship method" do
      before :each do
        @user = create(:user)
        @other_user = create(:other_user)
      end

      it "creates a new relationship with a status: blocked" do
        relationship = Relationship.create_blocked_relationship(@user, @other_user)
        expect(relationship.status).to eq "blocked"
      end

      it "updates a relationship with status: blocked if found" do
        Relationship.create({user_id: @user.id, other_user_id: @other_user.id, status: "default"})
        relationship = Relationship.create_blocked_relationship(@user, @other_user)
        expect(relationship.status).to eq "blocked"
      end
    end
  end
end