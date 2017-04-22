class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user

  ORE_PER_SEK = 100 # Öre per SEK

  def amount_in_ore
    ORE_PER_SEK * amount
  end

  def amount
    order_items.sum { |x| x.product.base_product.cost }
  end

  def complete!(stripe_charge)
    self.payment_method = 'Stripe'
    self.payment_data = stripe_charge.id
    save!
  end

  def has_owner?(owner)
    user == owner
  end
end
