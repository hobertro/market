class ItemsController < ApplicationController
  skip_before_filter :blocked_relationships?
  def index

  end

  def show
    @item = Item.find(params[:id])
  end
end
