require 'spec_helper'
require 'user'

describe User do
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