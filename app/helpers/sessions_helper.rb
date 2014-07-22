module SessionsHelper

    def sign_in(user)
      cookies.permanent[:remember_token] = user.remember_token
      self.current_user = user ## what is self ?
    end

    def current_user=(user)
      @current_user = user
    end

    def current_user
      @current_user ||= User.find_by_remember_token(cookies[:remember_token])
    end

    def current_user?(user)
      user == current_user
    end

    def signed_in?
      !current_user.nil?
    end

    def sign_out
      self.current_user = nil
      cookies.delete(:remember_token)
    end

    def signed_in_user
      unless signed_in?
        puts "signed_in_user_method"
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      if params[:user_id]
        @user = User.find(params[:user_id])
      else
        @user = User.find(params[:id])
      end
      redirect_to root_path unless current_user?(@user)
      # render :js => "window.location.pathname = '#{signin_path}'" unless current_user?(@user)
    end

    def find_item(item_id)
      Item.find_by_defindex(item_id.to_s)
    end

    def messenger_blocked?
      if Relationship.exists?(user_id: current_user.id, other_user_id: params[:recipient], status: "blocked") || 
         Relationship.exists?(user_id: params[:recipient], other_user_id: current_user.id, status: "blocked")
         redirect_to :root
      end
    end

    def blocked_relationships
      if blocked?
         redirect_to :root
      end
    end

    def blocked?
      if params[:user_id].blank?
        Relationship.exists?(user_id: current_user.id, other_user_id: params[:id], status: "blocked") ||
        Relationship.exists?(user_id: params[:id], other_user_id: current_user.id, status: "blocked")
      elsif
        Relationship.exists?(user_id: current_user.id, other_user_id: params[:recipient], status: "blocked") || 
        Relationship.exists?(user_id: params[:recipient], other_user_id: current_user.id, status: "blocked")
      else 
        Relationship.exists?(user_id: current_user.id, other_user_id: params[:user_id], status: "blocked") ||
        Relationship.exists?(user_id: params[:user_id], other_user_id: current_user.id, status: "blocked")
      end
    end

    def blocked_friends
        current_user.other_users
    end
end
  