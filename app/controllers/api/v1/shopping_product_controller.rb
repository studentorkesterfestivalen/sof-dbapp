class API::V1::ShoppingProductController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!, except: :index

  def index
    if current_user.present?
      if current_user.has_admin_permission? AdminPermission::ALL and params[:limit_items].nil?
        products = BaseProduct.all
      else
        enabled_products = BaseProduct.where(enabled: true)
        products = enabled_products.select { |x| current_user.has_admin_permission? x.required_permissions and current_user.has_group_permission? x.required_group_permissions }
      end
    else
      products = BaseProduct.where(enabled: true, required_permissions: 0, required_group_permissions: 0)
    end

    render :json => products, include: {
        products: {
            methods: [:actual_cost]
        }
    }
  end

  def create
    require_admin_permission AdminPermission::ALL

    product = BaseProduct.new(item_params)
    product.save!

    redirect_to api_v1_shopping_product_url(product)
  end

  def show
    render :json => BaseProduct.find_by_id(params[:id]), include: [:products]
  end

  def update
    require_admin_permission AdminPermission::ALL

    product = BaseProduct.find(params[:id])
    if product.update(item_params)
      redirect_to api_v1_shopping_product_url(product)
    else
      raise 'Unable to update product'
    end
  end

  def destroy
    raise 'Not implemented'
  end

  private

  def item_params
    filtered_params = params.require(:item).permit(
      :name,
      :description,
      :cost,
      :required_permissions,
      :required_group_permissions,
      :enabled,
      products_attributes: [
          :id,
          :kind,
          :cost,
          :enabled,
          :_destroy
      ]
    )

    if filtered_params[:products_attributes].nil?
      filtered_params[:products_attributes] = [
          {
              kind: nil,
              cost: 0,
              enabled: true
          }
      ]
    end

    filtered_params
  end
end
