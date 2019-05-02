class Cart < ApplicationRecord
  belongs_to :user

  belongs_to :discount_code, optional: true

  has_many :cart_items

  LINTEK_REBATES = {
      :thursday => 30,
      :friday => 20,
      :saturday => 20,
      :weekend => 90
  }

  LINTEK_ORCHESTRA_REBATES = {
      :thursday_saturday => 100,
      :friday_saturday => 100,
      :saturday => 30
  }

  def rebate
    # if user.is_lintek_member
    #   items = cart_items
    #   given_lintek_rebates = Set.new
    #   given_lintek_orchestra_rebates = Set.new
    #
    #   items.each do |item|
    #     if item.product.base_product.name == 'Dagsbiljett' or item.product.base_product.name == 'Endagsbiljett' or item.product.base_product.name == 'Helhelgsbiljett'
    #       if item.product.current_count(user, []) == 0
    #         case item.product.kind
    #           when 'Torsdag'
    #             given_lintek_rebates << :thursday
    #           when 'Fredag'
    #             given_lintek_rebates << :friday
    #           when 'Lördag'
    #             given_lintek_rebates << :saturday
    #           else
    #             given_lintek_rebates << :weekend
    #         end
    #       end
    #     elsif item.product.base_product.name == 'Orkesterbiljett'
    #       if item.product.current_count(user, []) == 0
    #         case item.product.kind
    #           when 'Torsdag - Lördag'
    #             given_lintek_orchestra_rebates << :thursday_saturday
    #           when 'Fredag - Lördag'
    #             given_lintek_orchestra_rebates << :friday_saturday
    #           else
    #             given_lintek_orchestra_rebates << :saturday
    #         end
    #       end
    #     end
    #
    #
    #   end
    #
    #   given_lintek_rebates.sum { |x| LINTEK_REBATES[x] } + given_lintek_orchestra_rebates.sum { |x| LINTEK_ORCHESTRA_REBATES[x] }
    # else
      0
    # end
  end

  def funkis_rebate
    order_items = cart_items.map { |x| create_order_item(x) }
    amount = order_items.sum { |x| x.product.actual_cost } - rebate
    [amount, user.rebate_balance].min
  end

  def clear!
    cart_items.each do |item|
      item.destroy!
    end
    self.discount_code = nil
    self.save!
    touch
  end

  def set_valid_through!(valid_to)
    self.valid_through = valid_to
    self.save!
  end

  def create_order
    order = Order.new
    order.user = user
    order.rebate = rebate
    order.order_items = cart_items.map { |x| create_order_item(x) }
    if !discount_code.nil?
      order.discount_code = discount_code
    end

    order.update_funkis_rebate
    order
  end

  def create_order_item(cart_item)
    item = OrderItem.new
    item.product = cart_item.product
    item.user = user
    item.owner = user
    item.cost = cart_item.product.actual_cost
    item.amount = cart_item.amount
    item
  end
end
