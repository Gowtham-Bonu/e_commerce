class Customer < ApplicationRecord
    has_many :orders, dependent: :destroy
    has_many :products, through: :orders

    validates :first_name, :email, :phone_number, presence: true
    validates :email, :phone_number, uniqueness: true
    validates :phone_number, length: { is: 10 }
end
