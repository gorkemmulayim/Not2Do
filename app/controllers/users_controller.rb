class UsersController < ApplicationController
    before_action :find_user, only: [:show, :edit, :update, :destroy, :following, :followers]

    def index
        @users = User.all.order("created_at DESC")

        respond_to do |format|
            format.html # show.html.erb
            format.json { render :json => {:user => @user, :users => @users } }
        end

        @users = User.search(params[:term])
    end

    def show
        @items = Item.where(user_id: @user.id).order("created_at DESC")
        participated_ids = Participation.where(user_id: @user.id).select(:item_id)
        @participated = Item.where(id: participated_ids)

        respond_to do |format|
          format.html # show.html.erb
          format.json { render :json => {:user => @user, :items => @items, :users => @participated } }
        end
    end

    def update
        if @user.update(params.require(:user).permit(:id, :name, :surname, :bio))
            redirect_to user_path(@user)
        else
            render 'edit'
        end
    end


    def destroy
        @user.destroy
        redirect_to root_path
    end


    def following
        following_ids = Follow.where(follower_id: @user.id).select(:followee_id)
        @following = User.where(id: following_ids)

        respond_to do |format|
          format.html # show.html.erb
          format.json { render :json => {:user => @user, :users => @following } }
        end
    end

    def followers
        follower_ids = Follow.where(followee_id: @user.id).select(:follower_id);
        @followers = User.where(id: follower_ids)

        respond_to do |format|
          format.html # show.html.erb
          format.json { render :json => {:user => @user, :users => @followers } }
        end
    end

    ### MOBILE API ###

    def sign_up
        email = params[:email]
        username = params[:username]
        name = params[:name]
        surname = params[:surname]
        password = params[:password]
        password_confirmation = params[:password_confirmation]
        new_user = User.new(email: email, username: username, name: name,
                            surname: surname, password: password,
                            password_confirmation: password_confirmation)
        if new_user.save
            render json: {error: false, user_id: new_user.id, token: new_user.id.to_s, username: new_user.username}
        else
            render json: {error: true, error_msg: "Email and username must be unique and, password and password confirmation must match!"}
        end
    end

    def edit_profile
        user_id = params[:user_id]
        email = params[:email]
        username = params[:username]
        name = params[:name]
        surname = params[:surname]
        bio = params[:bio]

        if user_id.blank? or email.blank? or username.blank? or name.blank? or surname.blank?
           render json: {error: true, error_msg: "Name, surname, username and email must not be empty"}
        else
            new_user = User.update(user_id, email: email, username: username, name: name,
                                    surname: surname, bio: bio)
            if new_user.save
                render json: {error: false, user_id: new_user.id, token: new_user.id.to_s, username: new_user.username}
            else
                render json: {error: true, error_msg: "Email and username must be unique"}
            end
        end
    end

    def log_in
        user = User.find_for_authentication(email: params[:email])

        if user != nil && user.valid_password?(params[:password])
            render json: {error: false, user_id: user.id, token: user.id.to_s, username: user.username}
        else
            user = User.find_for_authentication(username: params[:email])

            if user != nil && user.valid_password?(params[:password])
                render json: {error: false, user_id: user.id, token: user.id.to_s, username: user.username}
            else
                render json: {error: true, error_msg: "Email or password is invalid!"}
            end
        end

    end

    def timeline
        followings = Follow.where(follower_id: params[:user_id]).select(:followee_id)
        items = Item.where(user_id: followings).order("created_at DESC")
        users = User.where(id: items.select(:user_id))

        pcount = Hash.new
        fcount = Hash.new
        pbitmap = Hash.new
        fbitmap = Hash.new
        items.each  do |item|
            pcount[item.id] = Participation.where(item_id: item.id).count
            fcount[item.id] = Participation.where(item_id: item.id, failed: true).count
            if User.find(params[:user_id]).participating?(item)
                pbitmap[item.id] = true
                fbitmap[item.id] = Participation.where(user_id: params[:user_id], item_id: item.id).first.failed
            else
                pbitmap[item.id] = false
                fbitmap[item.id] = false
            end
        end

        render json: {items: items,
                      users: users,
                      participants_count: pcount,
                      failed_participants_count: fcount,
                      participated?: pbitmap,
                      failed?: fbitmap}
    end

    def discover
        items = Item.all.order("created_at DESC")
        users = User.where(id: items.select(:user_id))

        pcount = Hash.new
        fcount = Hash.new
        pbitmap = Hash.new
        fbitmap = Hash.new
        items.each  do |item|
            pcount[item.id] = Participation.where(item_id: item.id).count
            fcount[item.id] = Participation.where(item_id: item.id, failed: true).count
            if User.find(params[:user_id]).participating?(item)
                pbitmap[item.id] = true
                fbitmap[item.id] = Participation.where(user_id: params[:user_id], item_id: item.id).first.failed
            else
                pbitmap[item.id] = false
                fbitmap[item.id] = false
            end
        end

        render json: {items: items,
                      users: users,
                      participants_count: pcount,
                      failed_participants_count: fcount,
                      participated?: pbitmap,
                      failed?: fbitmap}
    end

    def all
        render json: {users: User.where.not(id: params[:user_id] ).order("username ASC")}
    end

    def profile
        user = User.find(params[:profile_id])
        is_following = User.find(params[:user_id]).following?(user)

        created_items = Item.where(user_id: user.id).order("created_at DESC")

        participated_ids = Participation.where(user_id: user.id).select(:item_id)
        participated_items = Item.where(id: participated_ids)

        users = User.where(id: participated_items.select(:user_id))

        followers_count = user.followers.count
        followings_count = user.following.count

        pcount = Hash.new
        fcount = Hash.new
        pbitmap = Hash.new
        fbitmap = Hash.new
        created_items.each  do |item|
            pcount[item.id] = Participation.where(item_id: item.id).count
            fcount[item.id] = Participation.where(item_id: item.id, failed: true).count
            if User.find(params[:user_id]).participating?(item)
                pbitmap[item.id] = true
                fbitmap[item.id] = Participation.where(user_id: params[:user_id], item_id: item.id).first.failed
            else
                pbitmap[item.id] = false
                fbitmap[item.id] = false
            end
        end
        participated_items.each  do |item|
            pcount[item.id] = Participation.where(item_id: item.id).count
            fcount[item.id] = Participation.where(item_id: item.id, failed: true).count
            if User.find(params[:user_id]).participating?(item)
                pbitmap[item.id] = true
                fbitmap[item.id] = Participation.where(user_id: params[:user_id], item_id: item.id).first.failed
            else
                pbitmap[item.id] = false
                fbitmap[item.id] = false
            end
        end

        render json: {user: user,
                      is_following: is_following,
                      followers_count: followers_count,
                      followings_count: followings_count,
                      created_items: created_items,
                      participated_items: participated_items,
                      users: users,
                      participants_count: pcount,
                      failed_participants_count: fcount,
                      participated?: pbitmap,
                      failed?: fbitmap }

    end

    def participate
        Participation.new(user_id: params[:user_id], item_id: params[:item_id]).save
    end

    def failed
        if Item.find(params[:item_id]).user_id == params[:user_id].to_i
            Item.find(params[:item_id]).update_attribute(:failed, true)
        else
            Participation.where(user_id: params[:user_id], item_id: params[:item_id]).first.update_attribute(:failed, true)
        end
    end

    def participants
        participant_ids = Participation.where(item_id: params[:item_id]).select(:user_id)
        render json: {users: User.where(id: participant_ids)}
    end

    def failed_participants
        failed_participant_ids = Participation.where(item_id: params[:item_id], failed: true).select(:user_id)
        render json: {users: User.where(id: failed_participant_ids)}
    end

    def follow
        User.find(params[:user_id]).follow(User.find(params[:profile_id]))
    end

    def unfollow
        User.find(params[:user_id]).unfollow(User.find(params[:profile_id]))
    end

    def followers2
        followers = Follow.where(followee_id: params[:profile_id]).select(:follower_id)
        render json: {users: User.where(id: followers)}
    end

    def followings2
        followings = Follow.where(follower_id: params[:profile_id]).select(:followee_id)
        render json: {users: User.where(id: followings)}
    end

    def create_item
        new_item = Item.new(title: params[:title], description: params[:description], user_id: params[:user_id])
        if new_item.save
            render json: {error: false, item_id: new_item.id}
        else
            render json: {error: true, error_msg: "Couldn't create the not2do..."}
        end
    end

    def delete_item
        Item.find(params[:item_id]).destroy
    end

    def set_fcm_token
      user = User.find(params[:user_id])
      user.update_attribute(:fcm_token, params[:fcm_token])
      render :json => { error: false }
    end

    private

    def find_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username)
    end

end