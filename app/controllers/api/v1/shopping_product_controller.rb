class API::V1::ShoppingProductController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!, except: :index

  def index
    if current_user.present?
      if current_user.has_admin_permission? AdminPermission::ALL and params[:limit_items].nil?
        products = BaseProduct.includes(:products).all
      else
        enabled_products = BaseProduct.order(:id).includes(:products).where('base_products.enabled': true, 'products.enabled': true)
        products = enabled_products.select { |x| current_user.has_admin_permission? x.required_permissions and current_user.has_group_permission? x.required_group_permissions }
      end
      products.each do |base_prod|
        base_prod.update_purchasable(current_user)
        base_prod.products.each do |prod|
          prod.current_user = current_user
        end
      end
    else
      products = BaseProduct.includes(:products).where(enabled: true, required_permissions: 0, required_group_permissions: 0)
    end


    render :json => products, methods: [], include: {
      products: {
        methods: [:actual_cost, :amount_left]
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

  def increase_count
    product = Product.find_by_id(params[:product_id])
    if product.nil?
      render :status => '404', :json => {:message => 'Ingen produkt hittades' }
    else
      product.increment(:separately_sold, 1)
      render :status => '200', :json => {:message => 'Antalet biljetter sålda minskad' }
    end
  end

  def decrease_count
    product = Product.find_by_id(params[:product_id])
    if product.nil?
      render :status => '404', :json => {:message => 'Ingen produkt hittades' }
    else
      product.decrement(:separately_sold, 1)
      render :status => '200', :json => {:message => 'Antalet biljetter sålda minskad' }
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
      :purchase_limit,
      :required_permissions,
      :required_group_permissions,
      :enabled,
      :giftable,
      :has_image,
      :image_path,
      products_attributes: [
          :id,
          :kind,
          :cost,
          :enabled,
          :max_num_available,
          :purchase_limit,
          :_destroy
      ]
    )

    if filtered_params[:products_attributes].nil?
      filtered_params[:products_attributes] = [
          {
              kind: nil,
              cost: nil,
              enabled: true
          }
      ]
    end

    filtered_params
  end
end
