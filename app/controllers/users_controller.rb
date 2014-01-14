class UsersController < ApplicationController
  def auth_callback
    auth = request.env['omniauth.auth']
    render :text => auth.info.to_hash.inspect
  end
end
