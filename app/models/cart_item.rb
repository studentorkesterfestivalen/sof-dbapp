class CartItem < ApplicationRecord
  # The term 'belongs_to' is a bit misleading but there is no real alternative if we want to use a local key
  # instead of a foreign key.
  belongs_to :product, class_name: 'ShoppingProduct'

  validate :has_existing_product, :data_contains_valid_json

  def data
    raw_data = super
    unless raw_data.blank?
      JSON.parse raw_data
    end
  end

  private

  def has_existing_product
    if product.nil?
      errors.add(:product, 'must exist')
    end
  end

  def data_contains_valid_json
    # Will raise exception on invalid json
    data
  end
end
