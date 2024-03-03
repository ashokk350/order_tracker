class Order < ApplicationRecord
	has_many :order_details, dependent: :destroy
	belongs_to :user

	accepts_nested_attributes_for :order_details
end
