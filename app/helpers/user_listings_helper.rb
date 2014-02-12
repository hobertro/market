module UserListingsHelper
    def user_listing(current_user)
        current_user.user_listings
    end
end
