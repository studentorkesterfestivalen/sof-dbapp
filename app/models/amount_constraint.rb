class AmountConstraint < ApplicationRecord
  has_and_belongs_to_many :products
end
