class API::V1::BaseProductController < ApplicationController
  include ViewPermissionConcern


  def statistics
    require_admin_permission AdminPermission::ANALYST

    render :json => BaseProduct.all, :include => {
        :products => {
            :methods => :amount_bought,
            :except => [:enabled, :base_product_id, :created_at, :updated_at]
        }
    }, :except => [:created_at, :updated_at, :giftable, :required_group_permissions, :enabled, :required_permissions]
  end
end
