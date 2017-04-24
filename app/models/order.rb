class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user

  ORE_PER_SEK = 100 # Öre per SEK

  def amount_in_ore
    ORE_PER_SEK * amount
  end

  def amount
    order_items.sum { |x| x.cost }
  end

  def complete!(stripe_charge)
    self.payment_method = 'Stripe'
    self.payment_data = stripe_charge.id
    save!
  end

  def complete_free_checkout!
    self.payment_method = 'Gratisköp'
    self.payment_data = 'Gratisköp'
    save!
  end

  def has_owner?(owner)
    user == owner
  end

  def purchasable?
    accepted_items = []
    order_items.each do |item|
      if item.purchasable?(accepted_items)
        accepted_items.push item
      end
    end

    accepted_items.length == order_items.length
  end
end
