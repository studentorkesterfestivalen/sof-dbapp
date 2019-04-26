class API::V1::PaymentController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def charge
    order = current_user.cart.create_order
    if order.purchasable?
      if order.amount == 0
        order.complete_free_checkout!
      else
        created_charge = create_charge!(order)
        order.complete!(created_charge)
      end
      current_user.cart.clear!
      render :status => 200, :json => {'message': "Successfully completed order"}
      # redirect_to api_v1_order_url(order)
    else
      head :not_acceptable
    end
  rescue Stripe::CardError => e
    raise e.message
  end

  private

  def create_charge!(order)
    customer = Stripe::Customer.create(
        :email => current_user.email,
        :source => params[:stripe_token],
    )

    products = ""
    order.order_items.each do |item|
      prod = Product.find_by(id: item.product_id)
      base_prod = BaseProduct.find_by(id: prod.base_product_id)
       # Some products have no name, add base_product name just in case
       unless prod.kind.nil?
         products += "\n" + item.amount.to_s + "x " + base_prod.name + "(" + prod.kind + ")" + "\n"
       else
         products += "\n" + item.amount.to_s + "x " + base_prod.name + "\n"
      end
    end

    Stripe::Charge.create(
        :customer => customer.id,
        :amount => order.amount_in_ore,
        :description => products,
        :currency => 'sek',
    )
  end
end
