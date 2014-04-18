class ContactMessage < ActiveRecord::Base
  attr_accessible :content, :from, :name, :to
  
end
