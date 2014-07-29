class Relationship < ActiveRecord::Base
  attr_accessible :other_user_id, :status, :user_id
  belongs_to :user
  belongs_to :other_user, class_name: "User"

  after_create :be_friendly_to_friend


  def be_friendly_to_friend
    other_user.other_users << user unless other_user.other_users.include?(user)
    self.save
  end

  def self.is_blocked_relationship?(user, other_user)
    exists?(user_id: user, other_user_id: other_user, status: "blocked") ||
    exists?(user_id: other_user, other_user_id: user, status: "blocked")
  end
end 