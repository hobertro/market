class SessionsController < ApplicationController
  def create
    auth = env['omniauth.auth']
    user = User.from_omniauth(auth)
    # add session code
    redirect_to :user 
  end
end
