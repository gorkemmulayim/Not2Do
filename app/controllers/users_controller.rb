class UsersController < ApplicationController
    before_action :find_user, only: [:show, :edit, :update, :destroy, :following, :followers]
    
    def index
        @users = User.all.order("created_at DESC")    
    end
    
    def show
        @items = Item.where(user_id: @user.id).order("created_at DESC")
        participated_ids = Participation.where(user_id: @user.id).select(:item_id)
        @participated = Item.where(id: participated_ids)
    end
    
    def destroy
        @user.destroy
        redirect_to root_path
    end
    
    def following
        following_ids = Follow.where(follower_id: @user.id).select(:followee_id)
        @following = User.where(id: following_ids)
    end
    
    def followers
        follower_ids = Follow.where(followee_id: @user.id).select(:follower_id);
        @followers = User.where(id: follower_ids)
    end
    
    private 
    
    def find_user
        @user = User.find(params[:id])        
    end
end
