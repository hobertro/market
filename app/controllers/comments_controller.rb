class CommentsController < ApplicationController
    before_filter :signed_in_user, only: [:create, :destroy]
    before_filter :correct_user, only: [:create, :destroy]


    def create
        @user = User.find(params[:user_id])
        @user_listing = UserListing.find(params[:listing_id])
        @comment = @user_listing.comments.build({description: params[:comment][:description], user_id: @user.id, user_listing_id: @user_listing.id})
        if @comment.save
          flash[:success] = "Comment created!"
          redirect_to([@user, @user_listing])
        else
            render 'static_pages/home'
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        @user_listing = @comment.user_listing
        @user = @comment.user
        @comment.destroy
        redirect_to user_user_listing_path(@user, @user_listing)
    end
end
