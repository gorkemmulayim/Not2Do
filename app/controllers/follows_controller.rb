class FollowsController < ApplicationController
    
    def create
        user = User.find(params[:followee_id])
        current_user.follow(user);
        redirect_back fallback_location: root_path
    end
    
    def destroy
        user = Follow.find(params[:id]).followee
        current_user.unfollow(user);
        redirect_back fallback_location: root_path
    end
    
end
