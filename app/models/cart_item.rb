class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validate :has_existing_product

  def add
    self.amount += 1
    self.save!
  end

  def remove
    self.amount -= 1
    self.save!
  end

  def set_amount amt
    self.amount = amt
    self.save!
  end

  def is_reserved
    return cart.valid_through > DateTime.now
  end

  private

  def has_existing_product
    if product.nil?
      errors.add(:product, 'must exist')
    end
  end
end
