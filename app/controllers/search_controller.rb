class SearchController < ApplicationController
  skip_before_filter :blocked_relationships?
  def new
  end

  def create
    @offered_items = JSON.parse(params[:offer])
    @wanted_items = JSON.parse(params[:wanted])
    
  end

  def show
    search_params = params[:search]
    puts search_params
    if search_params
       @user_listings = UserListing.joins(:items).where("lower(items.name) LIKE ? ", "%#{search_params.downcase}%").uniq.paginate(:page => params[:page]).per_page(10)
    else
        render :root_path
    end
  end

  def search
   
  end
end
