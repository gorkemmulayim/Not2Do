class User < ApplicationRecord
    validates :name, presence: true, length: { maximum: 64 }
    validates :surname, presence: true, length: { maximum: 64 }
    validates :username, presence: true, uniqueness: true, length: { maximum: 20 }
    validates :email, presence: true, uniqueness: true, length: { maximum: 64 }
    validates :password, presence: true, length: { maximum: 32 }
end
