class ParticipationsController < ApplicationController
    
    def create
        item = Item.find(params[:item_id])
        current_user.participate(item);
        redirect_back fallback_location: root_path
    end
    
    def fail
        participation = Participation.find(params[:id])
        participation.update_attribute(:failed, true)
        redirect_back fallback_location: root_path
    end

end
