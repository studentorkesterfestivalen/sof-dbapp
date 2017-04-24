class Product < ApplicationRecord
  belongs_to :base_product, required: false

  attr_reader :purchasable

  def actual_cost
    cost || base_product.cost
  end

  def update_purchasable(user)
    @purchasable = is_purchasable?(user, user.cart.cart_items)
  end

  def is_purchasable?(user, additional_items)
    below_user_limit?(user, additional_items) && below_global_limit?(additional_items)
  end

  def below_user_limit?(user, additional_items)
    if purchase_limit == 0
      true
    else
      current_count = current_count(user, additional_items)
      current_count < purchase_limit
    end
  end

  def below_global_limit?(additional_items)
    if max_num_available == 0
      true
    else
      current_count = additional_items.count { |x| x.product.id == id }
      current_count += OrderItem.where(product_id: id).count
      current_count < max_num_available
    end
  end

  def current_count(user, additional_items)
    (user.purchased_items + additional_items).count { |x| x.product.id == id }
  end
end
