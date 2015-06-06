FactoryGirl.define do
  factory :user do
    steam_id "123345"
    steam_name "fake_steam_name"
    avatar "www.avy.com"
    avatar_medium "www.avatar_medium.com"
    avatar_full "www.avatar_full.com"

    factory :other_user do
        steam_id "345345"
        steam_name "jon snow"
        avatar "secret"
        avatar_medium "super secret avy"
        avatar_full "ultiamte avy"
    end
  end
end