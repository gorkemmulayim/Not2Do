class Item < ActiveRecord::Base
    belongs_to :user
    
    has_many :passive_relationships2, class_name: "Participation", foreign_key: "item_id", dependent: :destroy 
end
