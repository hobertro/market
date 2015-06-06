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

    it "returns a list of blocked users with the #get_blocked_users method" do
      blocked_relationship = create(:blocked_relationship)
      blocked_users = Relationship.get_blocked_users(blocked_relationship.user)
      expect(blocked_users).to include(blocked_relationship.other_user_id)
    end

    it "returns a list of users with the #get_blocking_users method of the current user" do
      blocking_relationship = create(:blocked_relationship)
      get_blocking_users = Relationship.get_blocking_users(blocking_relationship.other_user_id)
      expect(get_blocking_users).to include(blocking_relationship.user_id)
    end

    it "unblocks a user with the #unblock_relationship method" do
      blocked_relationship = create(:blocked_relationship)
      unblocked_relationship = Relationship.unblock_relationship(blocked_relationship.user_id, 
                                                                 blocked_relationship.other_user_id)
      expect(unblocked_relationship.status).to eq "default"
    end
  end
end