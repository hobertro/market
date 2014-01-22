class UsersController < ApplicationController
  def auth_callback
    auth = request.env['omniauth.auth']
    # render :text => auth.info.to_hash.inspect
    @user = User.from_omniauth(auth)
    @items ||= @user.create_player_items(@user.steam_id)
    #render :show
    test = @user.items
    render :show
  end

  def index
  end

  def show
    render :text => "Hello" 
  end
end
