class SessionsController < ApplicationController
  def create
    auth = env['omniauth.auth']
    user = User.from_omniauth(auth)
    render :text => auth.info.name
  end
end
