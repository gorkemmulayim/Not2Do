class ParticipationsController < ApplicationController
    
    def create
        item = Item.find(params[:item_id])
        current_user.participate(item);
        redirect_to :back
    end
    
    def fail
        participation = Participation.find(params[:id])
        participation.update_attribute(:failed, true)
        redirect_to :back
    end

end
