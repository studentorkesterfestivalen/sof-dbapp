class ShoppingCart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  def empty!
    cart_items.delete_all
    touch
  end
end
