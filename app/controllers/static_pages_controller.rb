class StaticPagesController < ApplicationController
  def home
    @user = current_user
  end

  def about
    @user = current_user
  end

  def faq
    @user = current_user
  end

  def contact
    @user = current_user
  end
end