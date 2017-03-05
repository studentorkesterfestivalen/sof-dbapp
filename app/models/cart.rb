class Cart < ApplicationRecord
  has_many :cart_items

  def empty!
    cart_items.delete_all
    touch
  end
end
