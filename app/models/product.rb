class Product < ApplicationRecord
  belongs_to :base_product, required: false

  def actual_cost
    cost || base_product.cost
  end
end
