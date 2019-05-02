class DiscountCode < ApplicationRecord
  belongs_to :product, optional: true
  has_many :carts
  has_many :orders
end
