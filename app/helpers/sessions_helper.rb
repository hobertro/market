module SessionsHelper

    def sign_in(user)
      cookies.permanent[:remember_token] = user.remember_token
      self.current_user = user
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
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      # what is the purpose of this method?
      
      if params[:user_id]
        @user = User.find(params[:user_id])
      else
        @user = User.find(params[:id])
      end
      redirect_to root_path unless current_user?(@user)
      # render :js => "window.location.pathname = '#{signin_path}'" unless current_user?(@user)
    end
end
  



  