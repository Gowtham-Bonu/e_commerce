class Order < ApplicationRecord
    belongs_to :customer
    belongs_to :product

    validates :quantity, :status, :customer_id, presence: true 
end
