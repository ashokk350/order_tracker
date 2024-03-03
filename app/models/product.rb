class Product < ApplicationRecord
	has_many :order_detail

	validates :code, uniqueness: true 
	validates :code, :name, presence: true
end
