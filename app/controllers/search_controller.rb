class SearchController < ApplicationController
  def new
  end

  def create
    @offered_items = JSON.parse(params[:offer])
    @wanted_items = JSON.parse(params[:wanted])
    
  end

  def show
  end

  def search
    search_params = params[:search]
    puts search_params
    if search_params
       item_results = Item.where('name LIKE ?', "%#{search_params}%")
    else
        render :root_path
    end
    puts "after logic"
    render :json => item_results
  end
end
