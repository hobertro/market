class ItemsController < ApplicationController
  def index
    @user = current_user
  end

  def show
    @user = current_user
    @item = Item.find(params[:id])
  end
end
