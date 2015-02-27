# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'webmock/rspec'
require 'shoulda/matchers'


WebMock.disable_net_connect!(allow_localhost: true)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec


  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.include IntegrationSpecHelper, :type => :feature
end

Capybara.default_host = 'http://localhost:3000'
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:steam] = OmniAuth::AuthHash.new({
        :avatar            => "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/ae/aefae2e5855b48bdc6ac522ca2bac705ad3e8930.jpg",
        :avatarfull        => "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/ae/aefae2e5855b48bdc6ac522ca2bac705ad3e8930_full.jpg",
        :avatarmedium      => "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/ae/aefae2e5855b48bdc6ac522ca2bac705ad3e8930_medium.jpg",
        :commentpermission => 1,
        :communityvisibilitystate => 3,
        :profilestate => "who knows",
        :last_logoff => "don't know",
        :profile_url => "www.steam.com",
        :steam_id => "steam_id",
        :steam_name => "steam_name",
        :primaryclanid => "1",
        :timecreated => "forgot",
        :person_state => "strangers in the fire"
    })