class Follow < ActiveRecord::Base
    belongs_to :follower, class_name: "User"
    belongs_to :followee, class_name: "User"
    validates :follower_id, presence: true
    validates :followee_id, presence: true

    after_commit :send_notification_to_followee, on: :create

    def send_notification_to_followee
      follower = User.find_by_id(self.follower_id)
      followee =  User.find_by_id(self.followee_id)
      fcm = FCM.new(ENV[FCM_KEY])
      registration_ids = Array.wrap(followee.fcm_token)
      options = {data: {message: "\"#{follower.name} #{follower.surname} is following you.\""}}
      fcm.send(registration_ids, options)
    end
end
