class User < ActiveRecord::Base
  has_many :items, dependent: :destroy
  
  has_many :active_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy 
  has_many :passive_relationships, class_name: "Follow", foreign_key: "followee_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followee
  has_many :followers, through: :passive_relationships, source: :follower
  
  has_many :active_relationships2, class_name: "Participation", foreign_key: "user_id", dependent: :destroy
  
  def follow(other)
    active_relationships.create(followee_id: other.id)
  end
  
  def unfollow(other)
    active_relationships.find_by(followee_id: other.id).destroy
  end
  
  def following?(other)
    following.include?(other)
  end
  
  def participate(item)
    active_relationships2.create(item_id: item.id)
  end
  
  def participating?(item)
    !Participation.where(item_id: item.id, user_id: self.id).empty?
  end
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates_uniqueness_of :username, :email

end
