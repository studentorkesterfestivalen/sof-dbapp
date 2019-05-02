class DiscountCode < ApplicationRecord
  belongs_to :product, optional: true
  has_many :carts
  has_many :orders

  def usable?(cart)
    times_used = 0
    if !product.nil?
      has_discount_item = false
      cart.cart_items.each {|item| has_discount_item ||= (item.product == product)}
      if !has_discount_item
        return false
      end
    end
    orders.each {|order| times_used+= 1}

    carts.each do |cart|
      if cart.valid_through > DateTime.now
        times_used += 1
      end
    end
    p times_used
    times_used < uses
  end
end
