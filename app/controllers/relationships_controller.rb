class RelationshipsController < ApplicationController

  before_filter :signed_in_user, only: [:create, :destroy, :new, :edit]
  before_filter :correct_user, only: [:create, :destroy, :new, :edit]

  def new
  end

  def create
    user = User.find(params[:user_id])
    blocked_user = User.find(params[:blocked_user])
    unless user.relationships.find_by_other_user_id(params[:blocked_user])
      user.relationships.create({:status => "blocked", :other_user_id => params[:blocked_user]})
    end
      flash[:success] = "You have successfully blocked #{blocked_user.steam_name}"
      redirect_to :root
  end

  def edit
  end

  def destroy
  end

end
