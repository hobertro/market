class UsersController < ApplicationController
  def auth_callback
    auth = request.env['omniauth.auth']
    # render :text => auth.info.to_hash.inspect
    @user = User.from_omniauth(auth)
    @items = User.get_user_items(@user.steam_id)["result"]["items"]
    #render :show
    test = Item.first
    render :text => test.name
  end

  def index
  end

  def show
    render :text => "Hello" 
  end
end
