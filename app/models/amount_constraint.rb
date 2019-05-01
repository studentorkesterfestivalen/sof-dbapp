class AmountConstraint < ApplicationRecord
  has_and_belongs_to_many :products

  def amount_left
    amount_left = amount
    products.each do |prod|
      amount_left -= prod.amount_bought
    end

    amount_left
  end
end
