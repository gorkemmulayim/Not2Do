class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 64 }
  validates :surname, presence: true, length: { maximum: 64 }
  validates :username, presence: true, uniqueness: true, length: { maximum: 20 },
    format: { with: /\A[a-zA-Z0-9]+\Z/,
    message: "can only contain alphanumeric characters (letters A-Z, numbers 0-9)." }
  validates :email, presence: true, uniqueness: true, length: { maximum: 64 }
  validates :password, presence: true, length: { maximum: 32 }
end
