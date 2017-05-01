class API::V1::OrderItemController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    items = {
        owned: current_user.owned_items,
        purchased: current_user.purchased_items
    }

    render :json => items, include: {
        product: {
            include: [:base_product]
        }
    }
  end

  def show
    order_item = OrderItem.find(params[:id])
    require_membership_or_admin_permission order_item, AdminPermission::ALL

    render :json => order_item, include: {
        product: {
            include: [:base_product]
        },
        user: {},
        owner: {},
        gifted_by: {}
    }
  end

  def update
    order_item = OrderItem.find(params[:id])
    require_ownership_or_admin_permission order_item, AdminPermission::ALL

    unless order_item.product.base_product.giftable
      raise 'Product is not giftable'
    end

    new_owner = User.find_by email: params[:item][:owner]
    if new_owner.nil?
      raise 'Unable to find user'
    end

    if order_item.update({owner: new_owner, gifted_by: current_user})
      redirect_to api_v1_order_item_url(order_item)
    else
      raise 'Unable to change owner'
    end
  end

  def all_items
    require_admin_permission AdminPermission::ANALYST

    # Todo: Sort items in a nice json with only the needed fields, instead of the GIANT motherfkingblob that is spawned with the command below.
    base_products = BaseProduct.all
    products = Product.all
    all_items = OrderItem.all

    resultJson = {}

    render :json => resultJson
  end

  private

  # TODO: Remove, this is just for me to have a better view of what Im creating
  def all_items_json
    {
        _base_product_: {
            name: 'xxx',
            price: 'xxx',

            _products_: {
                name: 'xx',
                price: 'xx',
                amount_bought: 'xx',
                max_limit: 'xx'
            }
        }
    }

  end
end
