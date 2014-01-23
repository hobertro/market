class UsersController < ApplicationController
  def auth_callback
    auth = request.env['omniauth.auth']
    # render :text => auth.info.to_hash.inspect
    @user = User.from_omniauth(auth)
    if @user.user_items.empty?
      @items = @user.create_player_items(@user.steam_id)
    else 
    redirect_to action: :show, id: @user.id
    end
  end

  def index
  end

  def show
    @user = User.find(params[:id])
  end
end
