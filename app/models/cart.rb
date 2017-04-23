class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  def empty!
    cart_items.delete_all
    touch
  end

  def create_order
    order = Order.new
    order.user = user
    order.order_items = cart_items.map { |x| create_order_item(x) }
    order
  end

  def create_order_item(cart_item)
    item = OrderItem.new
    item.product = cart_item.product
    item.user = user
    item.owner = user
    item.cost = cart_item.product.base_product.cost
    item
  end
end
