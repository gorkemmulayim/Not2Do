class ItemsController < ApplicationController
    before_action :find_item, only: [:show, :edit, :update, :destroy, :participants, :fail, :failed_participants]
    
    def index
        if user_signed_in?
            followings = Follow.where(follower_id: current_user.id).select(:followee_id)
            @items = Item.where(user_id: followings).order("created_at DESC")
        
            respond_to do |format|
                format.html # show.html.erb
                format.json { render :json => {:item => @item, :items => @items, :users => @followings } }
            end
        end
    end
    
    def new
        @item = current_user.items.build
    
        # Bu burda olmalı mı olmamalı mı yoksa hiç değişmemeli mi?
        respond_to do |format|
            format.html # show.html.erb
            format.json { render :json => {:item => @item } }
        end
    end
    
    def create
        @item = current_user.items.build(item_params)
        if @item.save
            redirect_to root_path
        else
            render 'new'
        end
    
        respond_to do |format|
            format.html # show.html.erb
            format.json { render :json => {:item => @item } }
        end
    end
    
    def show
        
        
        respond_to do |format|
            format.html # show.html.erb
            format.json { render :json => {:item => @item } }
        end
    end
    
    def edit
        
        
        respond_to do |format|
            format.html # show.html.erb
            format.json { render :json => {:item => @item } }
        end
    end
    
    def update
        if @item.update(item_params)
            redirect_to item_path(@item)
        else
            render 'edit'
        end
        
        respond_to do |format|
            format.html # show.html.erb
            format.json { render :json => {:item => @item } }
        end
    end
    
    def destroy
        @item.destroy
        redirect_to root_path
    end
    
    def participants
        participant_ids = Participation.where(item_id: @item.id).select(:user_id)
        @participants = User.where(id: participant_ids)
    
        respond_to do |format|
            format.html # show.html.erb
            format.json { render :json => {:item => @item, :users => @participants } }
        end
    end
    
    def fail
        @item.update_attribute(:failed, true)
        redirect_back fallback_location: root_path
    end
    
    def failed_participants
        failed_participant_ids = Participation.where(item_id: @item.id, failed: true).select(:user_id)
        @failed_participants = User.where(id: failed_participant_ids)
    
        respond_to do |format|
            format.html # show.html.erb
            format.json { render :json => {:item => @item, :users => @failed_participants } }
        end
    end
    
    private 
    
    def item_params
        params.require(:item).permit(:title, :description)
    end
    
    def find_item
        @item = Item.find(params[:id])        
    end
end
