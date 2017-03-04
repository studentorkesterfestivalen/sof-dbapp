class CartItem < ApplicationRecord
  belongs_to :product

  validate :has_existing_product

  private

  def has_existing_product
    if product.nil?
      errors.add(:product, 'must exist')
    end
  end
end
