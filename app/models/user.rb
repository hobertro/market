class User < ActiveRecord::Base
  attr_accessible :steam_id, :steam_name
 
  def self.from_omniauth(auth)
    @authorization = User.find_by_steam_id(auth["uid"])
    if @authorization
        return @authorization
    else
        self.create_from_omniauth(auth)
    end
  end

  def self.create_from_omniauth(auth)
    User.create!({"steam_id" => auth["uid"], "steam_name" => auth.info.name})
  end
end
