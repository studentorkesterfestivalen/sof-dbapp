class AmountConstraint < ApplicationRecord
  has_and_belongs_to_many :products

  def amount_left
    amount_left = amount
    p amount_left
    products.each do |prod|
      p prod
      p prod.amount_bought
      amount_left -= prod.amount_bought
    end
    p amount_left

    amount_left
  end
end
