class API::V1::ShoppingCartController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: current_user.cart,
      include: [
        :cart_items
    ]
  end

  def clear
    current_user.cart.clear!
  end

  def add_item
    item = current_user.cart.cart_items.find_by product_id: item_params[:product_id]
    if item.nil?
      item = CartItem.new(item_params)
      item.save!
      current_user.cart.cart_items.push(item)
      current_user.cart.touch
    end
    item.add
  end

  def delete_item
    p item_params
    item = current_user.cart.cart_items.find_by product_id: item_params[:product_id]
    item.remove
    if !item.nil? && item.amount <= 0
      item.destroy!
    end
  end

  def set_item_amount
    item = current_user.cart.cart_items.find_by product_id: item_params[:product_id]
    if item.nil?
      item = CartItem.new(item_params)
      item.save!
      current_user.cart.cart_items.push(item)
      current_user.cart.touch
    else
      item.set_amount item_param[:amount]
    end
  end

  def set_cart
    clear()

    purchasable = true

    for item_params in cart_params[:items]
      prod = Product.find_by id: item_params[:product_id]
      purchasable &&= prod.is_purchasable?(current_user, item_params[:amount])
    end

    if purchasable
      for item_params in cart_params[:items]
        item = CartItem.new(item_params)
        item.save!
        current_user.cart.cart_items.push(item)
        current_user.cart.touch
      end

      current_user.cart.set_valid_through! 5.minutes.from_now
    else 
      render :status => 406, :json => 'Items are sold out'
    end
  end

  private

  def item_params
    params.require(:item).permit(
      :product_id,
      :amount
    )
  end

  def cart_params
    params.require(:cart).permit(
      items: [:product_id, :amount]
    )
  end

end
