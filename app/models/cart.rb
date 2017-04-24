class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  LINTEK_REBATES = {
      :thursday => 30,
      :friday => 20,
      :saturday => 20,
      :weekend => 90
  }

  def rebate
    items = cart_items
    given_lintek_rebates = Set.new

    items.each do |item|
      if item.product.base_product.name == 'Dagsbiljett' or item.product.base_product.name == 'Helhelgsbiljett'
        if item.product.current_count(user, []) == 0
          case item.product.kind
            when 'Torsdag'
              given_lintek_rebates << :thursday
            when 'Fredag'
              given_lintek_rebates << :friday
            when 'Lördag'
              given_lintek_rebates << :saturday
            else
              given_lintek_rebates << :weekend
          end
        end
      end
    end

    given_lintek_rebates.sum { |x| LINTEK_REBATES[x] }
  end

  def empty!
    cart_items.delete_all
    touch
  end

  def create_order
    order = Order.new
    order.user = user
    order.rebate = rebate
    order.order_items = cart_items.map { |x| create_order_item(x) }
    order
  end

  def create_order_item(cart_item)
    item = OrderItem.new
    item.product = cart_item.product
    item.user = user
    item.owner = user
    item.cost = cart_item.product.actual_cost
    item
  end
end
