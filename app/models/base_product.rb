class BaseProduct < ApplicationRecord
  has_many :products

  accepts_nested_attributes_for :products, allow_destroy: true

  attr_reader :purchasable

  def update_purchasable(user)
    @purchasable = is_purchasable?(user, user.cart.cart_items)
    products.each { |x| x.update_purchasable(user) }
  end

  def is_purchasable?(user, additional_items)
    below_user_limit?(user, additional_items)
  end

  def below_user_limit?(user, additional_items)
    if purchase_limit == 0
      true
    else
      current_count = (user.purchased_items + additional_items).count { |x| x.product.base_product.id == id }
      current_count < purchase_limit
    end
  end
end
