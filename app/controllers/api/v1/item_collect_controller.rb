require 'kobra'

class API::V1::ItemCollectController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!


  def show
    require_admin_permission AdminPermission::TICKETER

    user = User.find_by id: params[:id]

    if user.present?
      render json: user, include: {
          owned_items: {
              include: {
                product: {
                    include: [:base_product]
                }
              }
          }
      }
    else
      render :status => '404', :json => {:message => 'Användare kunde inte hittas'}
    end

  end

  def collect
    require_admin_permission AdminPermission::TICKETER

    collected_ids = params[:collected_ids]
    collected_ids.each do |order_item_id|
      order_item = OrderItem.find_by id: order_item_id
      order_item.collected = true
      order_item.collected_at = DateTime.now
      order_item.save!
    end

    render :status => '200', :json => {}
  end
end
