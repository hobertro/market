class SessionsController < ApplicationController
  def create
      # move specific user creation to a method on the User model
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)
    user.have_items?
    sign_in user
    redirect_to controller: :users, action: :show, id: user.id
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
