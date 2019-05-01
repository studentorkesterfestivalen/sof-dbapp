class Product < ApplicationRecord
  belongs_to :base_product, required: false

  has_many :cart_items
  has_and_belongs_to_many :amount_constraints

  def actual_cost
    cost || base_product.cost
  end

  def update_purchasable(user)
    @purchasable = is_purchasable?(user, user.cart.cart_items)
  end

  def is_purchasable?(user, additional_items)
    enabled && below_user_limit?(user, additional_items) && below_global_limit?(additional_items)
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
    current_count = 0
    additional_items.to_a.each do |item|
      if item.product.id == id
        current_count += item.amount
      end
    end
    current_count += amount_bought
    current_count < amount_left
  end

  def current_count(user, additional_items)
    (user.purchased_items + additional_items).count { |x| x.product.id == id }
  end

  def amount_reserved
    reserved_amt = 0
    reserved_items = cart_items.select{|c_item| c_item.is_reserved}
    reserved_items.each do |item|
      reserved_amt += item.amount
    end

    reserved_amt
  end

  def amount_left
    smallest_amount = -1
    if max_num_available > 0
      smallest_amount = max_num_available - amount_bought - amount_reserved
    end

    amount_constraints.each do |constraint|
      p 'constr'
      p constraint
      p constraint.amount_left
      p amount_reserved
      p '---DONE---'
      amt = constraint.amount_left - amount_reserved
      if(smallest_amount == -1 || amt < smallest_amount)
        smallest_amount = amt
        p "smallest amount now " + amt.to_s
      end
    end

    smallest_amount
  end

  def amount_bought
    OrderItem.where(product_id: id).sum{ |prod| prod.amount } + given_out_amount
  end


end
