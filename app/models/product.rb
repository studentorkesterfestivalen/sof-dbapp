class Product < ApplicationRecord
  belongs_to :base_product, required: false
end