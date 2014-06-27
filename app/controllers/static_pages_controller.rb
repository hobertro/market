class StaticPagesController < ApplicationController
  def home
    # @listings = UserListing.all
    @listings = UserListing.paginate(:page => params[:page]).per_page(10)
  end

  def about
  end

  def faq
  end

  def contact
  end

  def search
  end
end
