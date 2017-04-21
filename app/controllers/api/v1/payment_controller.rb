class API::V1::PaymentController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def charge
    order = current_user.cart.create_order
    created_charge = create_charge!
    order.complete! created_charge

    head :no_content
  rescue Stripe::CardError => e
    raise e.message
  end

  private

  def create_charge!
    customer = Stripe::Customer.create(
        :email => current_user.email,
        :source => params[:stripe_token],
    )

    Stripe::Charge.create(
        :customer => customer.id,
        :amount => order.total_cost,
        :description => 'Köp på www.sof17.se',
        :currency => 'sek',
    )
  end
end
