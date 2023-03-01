class Product < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :customers, through: :orders

  enum :status, [:in_stock, :out_of_stock, :coming_soon]
  default_scope { where(is_active: true) }
  validates :title, :price, :capacity, :status, presence: true
end
