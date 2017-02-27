class ShoppingOrder < ApplicationRecord
  belongs_to :user
  has_many :shopping_items

  # TODO
  def total_cost
    return 420
  end
end
