require "rails_helper"

describe "Authentication" do
  subject { page }
  describe "Signing in " do
    before { visit root_path }
    describe "with valid information" do
      before do
        login_with_oauth
      end
      it "has a link with 'Backpack" do
        expect(page).to have_selector('a', "Backpack")
      end
      it "has a link with 'User Listings" do
        expect(page).to have_selector('a', "User Listings")
      end
      it "has a link with 'New Listing" do
        expect(page).to have_selector('a', "New Listing")
      end
      it "has a link with 'Listings" do
        expect(page).to have_selector('a', "Listings")
      end
    end
  end
end