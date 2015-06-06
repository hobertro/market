class RelationshipsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :new, :edit]
  before_filter :correct_user, only: [:create, :destroy, :new, :edit]

  def new
  end

  def create
    blocked_user = User.find(params[:blocked_user])
    Relationship.create_blocked_relationship(params[:user_id], blocked_user)    
    flash[:success] = "You have successfully blocked #{blocked_user.steam_name}"
    redirect_to :root
  end

  def update
    user = User.find(params[:user_id])
    Relationship.unblock_relationship(params[:user_id], params[:blocked_user_id])
    redirect_to edit_user_path(user)
  end

  def edit
  end

  def destroy
  end

end
