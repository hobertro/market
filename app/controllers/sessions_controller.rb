class SessionsController < ApplicationController
  def create
      # move specific user creation to a method on the User model
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)
    if @user.user_items.empty?
      begin
        @items = @user.create_player_items(@user.steam_id)
      rescue
        puts "hihi"
      end
      # @items = @user.create_player_items
      # create item_id_if_not_exist, if exists, then return, make it indempotent
      # put flag on db on the user, put false by default, everytime you scan user items, put to true
      # code should be in the model, not the controller
      # create if_not_exist_method
    end
      sign_in @user
      redirect_to controller: :users, action: :show, id: @user.id
      #  need to refactor
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
