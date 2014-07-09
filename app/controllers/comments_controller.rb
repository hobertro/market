class CommentsController < ApplicationController
    before_filter :signed_in_user, only: [:create, :destroy]
    before_filter :correct_user, only: [:destroy]

    def create
        @user = User.find(params[:user_id])
        @user_listing = UserListing.find(params[:listing_id])
        @comment = @user_listing.comments.build({description: params[:comment][:description], user_id: @user.id, user_listing_id: @user_listing.id})
        if @comment.save
          flash[:success] = "Congratulations! Your comment was created!"
          redirect_to([@user, @user_listing])
        else
          flash[:notice] = "Sorry, something went wrong!"
          redirect_to([@user, @user_listing])
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        @user_listing = @comment.user_listing
        @user = @comment.user
        if @comment.destroy
            flash[:success] = "Your comment has been deleted"
        else 
            flash[:danger] = "Something went wrong!"
        end
        redirect_to user_user_listing_path(@user, @user_listing)
    end
end
    