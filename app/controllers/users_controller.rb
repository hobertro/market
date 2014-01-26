class UsersController < ApplicationController
  def auth_callback
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)
    sign_in @user
    if @user.user_items.empty?
      @items = @user.create_player_items(@user.steam_id)
      # create item_id_if_not_exist, if exists, then return, make it indempotent
      # put flag on db on the user, put false by default, everytime you scan user items, put to true
      # code should be in the model, not the controller
      # create if_not_exist_method
    end
      redirect_to action: :show, id: @user.id
  end

  def index
  end

  def show
    @user = User.find(params[:id])
  end
end
