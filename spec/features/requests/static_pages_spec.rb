require "rails_helper"

describe "Static Pages" do
  describe "Contact Page" do
    it "should have h1 'Contact" do
      visit '/static_pages/contact' 
      expect(page).to have_selector('h1', text: 'Contact')
    end
  end
end