class API::V1::PaymentController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def charge
    order = current_user.cart.create_order
    if !current_user.cart.cart_items.empty? && order.purchasable?
      if order.cost == 0
        order.complete_free_checkout!
      else
        created_charge = create_charge!(order)
        print created_charge
        order.complete!(created_charge)
      end
      current_user.cart.clear!
      render :status => 200, :json => {'message': "Successfully completed order"}
      # redirect_to api_v1_order_url(order)
    else
      render :status => 406, :json => {'message': "Empty cart or items that can't be purchased"}
      #head :not_acceptable
    end
  rescue Stripe::CardError => e
    render :status => 400, :json => e
  rescue Stripe::RateLimitError => e
    render :status => 400, :json => e
  rescue Stripe::InvalidRequestError => e
    render :status => 400, :json => e
  rescue Stripe::AuthenticationError => e
    render :status => 400, :json => e
  rescue Stripe::APIConnectionError => e
    render :status => 400, :json => e
  rescue Stripe::StripeError => e
    render :status => 400, :json => e

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
         products += "" + item.amount.to_s + "x " + base_prod.name + "(" + prod.kind + ")" + "\n"
       else
         products += "" + item.amount.to_s + "x " + base_prod.name + "\n"
      end
    end

    Stripe::Charge.create(
        :customer => customer.id,
        :amount => order.cost_in_ore,
        :description => products,
        :currency => 'sek',
    )

  end
end
