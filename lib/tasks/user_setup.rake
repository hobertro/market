namespace :setup do

  desc "creates fake blocked relationships"
  task :create_blocked_relationships do
    User.all.each do |user|
      5.times do 
        last_number   = User.last.id
        random_number = rand(last_number)
        user.relationships.create({other_user_id: random_number, status: "blocked"}) 
      end
    end
  end
end