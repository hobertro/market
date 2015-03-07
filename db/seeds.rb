# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



3.times do
  fake_user = User.create! do |user|
    user.steam_id   = "123456"
    user.steam_name =  Faker::Name.name
    user.avatar        = Faker::Avatar.image 
    user.avatar_medium = Faker::Avatar.image
    user.avatar_full   = Faker::Avatar.image
  end

  10.times do
    fl_userlisting = fake_user.user_listings.new()
    (2010..2015).each do |item_id|
      offered_item = fl_userlisting.item_listings.build({"item_id" => item_id, "status" =>"offered"})
    end
    (3010..3015).each do |item_id|
      wanted_item = fl_userlisting.item_listings.build({"item_id" => item_id, "status" => "wanted"})
    end
    fl_userlisting.comments.build({"user_listing_id" => fl_userlisting.id, "user_id" => fake_user.id, "description" => Faker::Lorem.sentence })
    fl_userlisting.save!
  end

  10.times do 
    fake_user.messages.create! do |message|
      message.recipient_id = User.find(16).id
      message.content = Faker::Lorem.sentence
    end
  end
end