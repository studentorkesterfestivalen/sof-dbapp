  class API::V1::OrderController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    render :json => current_user.orders, methods: [:amount]
  end

  def show
    order = Order.find(params[:id])
    require_ownership_or_admin_permission order, AdminPermission::ALL

    render :json => order, include: {order_items: {
        include: {
            product: {
                include: [:base_product]
            },
            owner: {}
        }
    },
    receipt_url:
  }
  end
end
