FactoryGirl.define do
  factory :relationship do
    user_id 1
    other_user_id 2
    status "default"
    association :user
    factory :blocked_relationship do
        user_id 1
        other_user_id 2
        status "blocked"
    end
    factory :blocking_relationship do
        user_id 2
        other_user_id 1
        status "blocked"
    end
  end
end