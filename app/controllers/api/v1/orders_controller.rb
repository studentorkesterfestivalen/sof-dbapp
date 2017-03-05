class API::V1::OrdersController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def new
  end

  def create
    customer = Stripe::Customer.create(
        :email => params[:email],
        :source => params[:token],
    )

    # TODO
    #@order_id = create_order()
    @order_id = 1

    charge(customer, @order_id, params[:amount])
  end

  def charge(customer, order_id, amount)
    current_charge = Stripe::Charge.create(
        :customer => customer.id,
        :amount => amount, # amount in öre SEK
        :description => params[:description],
        :metadata => {'order_id' => order_id},
        :currency => 'sek',
    )
    # TODO
    #complete_order(order_id)

  rescue Stripe::CardError => e
    raise e.message
    #redirect_to new_payment_path
  end
end
