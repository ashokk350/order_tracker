class User < ApplicationRecord
	has_many :orders

	validates :email, uniqueness: true 
	validates :username, :email, presence: true
end
