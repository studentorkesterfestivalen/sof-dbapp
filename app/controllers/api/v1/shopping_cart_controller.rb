class API::V1::ShoppingCartController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: current_user.shopping_cart, include: [cart_items: {include: [:product]}]
  end

  def clear
    current_user.shopping_cart.empty!

    head :no_content
  end

  def add_item
    item = CartItem.new(item_params)
    item.save!

    current_user.shopping_cart.cart_items.push(item)
    current_user.shopping_cart.touch

    head :no_content
  end

  def delete_item
    current_user.shopping_cart.cart_items.destroy params[:id]
  end

  private

  def item_params
    params.require(:item).permit(
      :product_id,
      :data
    )
  end

end
