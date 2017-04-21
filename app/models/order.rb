class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user

  ORE_PER_SEK = 100 # Öre per SEK

  def total_cost
    ORE_PER_SEK * order_items.sum { |x| x.product.base_product.cost }
  end

  def complete!(stripe_charge)
    self.payment_method = 'Stripe'
    self.payment_data = stripe_charge.id
    save!
  end
end
