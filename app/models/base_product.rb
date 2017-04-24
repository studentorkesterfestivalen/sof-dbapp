class BaseProduct < ApplicationRecord
  has_many :products

  accepts_nested_attributes_for :products, allow_destroy: true

  attr_reader :purchasable

  def update_purchasable(user)
    @purchasable = is_purchasable?(user, user.cart.cart_items)
    products.each { |x| x.update_purchasable(user) }
  end

  def is_purchasable?(user, additional_items)
    below_user_limit?(user, additional_items) && has_sufficient_permissions?(user)
  end

  def below_user_limit?(user, additional_items)
    if purchase_limit == 0
      true
    else
      current_count = (user.purchased_items + additional_items).count { |x| x.product.base_product.id == id }
      current_count < purchase_limit
    end
  end

  def has_sufficient_permissions?(user)
    user.has_admin_permission?(required_permissions) && user.has_group_permission?(required_group_permissions)
  end
end
