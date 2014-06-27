class CommentsController < ApplicationController
    before_filter :signed_in_user, only: [:create, :destroy]
    before_filter :correct_user, only: [:destroy]

    def create
        @user = User.find(params[:user_id])
        @listings = UserListing.find(params[:listing_id])
        @comment = @listings.comments.build({description: params[:comment][:description], user_id: @user.id, user_listing_id: @listings.id})
        if @comment.save
          flash[:success] = "Congratulations! Your comment was created!"
          redirect_to([@user, @listings])
        else
          flash[:notice] = "Sorry, something went wrong!"
          redirect_to([@user, @listings])
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
    