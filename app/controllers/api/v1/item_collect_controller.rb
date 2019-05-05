# require 'kobra'

class API::V1::ItemCollectController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!


  def show
    require_admin_permission AdminPermission::TICKETER
    
    user = User.find_by uuid: params[:uuid]

    if user.present?
      render_order_items(user)
    else
      render :status => '404', :json => {:message => 'Användare kunde inte hittas'}  
    end
  end


  def liu_card 
    require_admin_permission AdminPermission::TICKETER
    
    user = User.find_by liu_card_number: params[:liu_card_number]
    
    if user.present? 
      render_order_items(user)
    else
      render :status => '404', :json => {:message => 'Användare kunde inte hittas'}  
    end
  end

  def collect
    require_admin_permission AdminPermission::TICKETER
    
    user = User.find_by id: params[:id]

    unless user.present?
      render :status => '404', :json => {:message => 'Användare kunde inte hittas'} 
    else 
      collected_ids = params[:collected_ids]
      collected_ids.each do |order_item_id|
        order_item = OrderItem.find_by id: order_item_id
        order_item.collected = true
        order_item.collected_at = DateTime.now
        order_item.save!
        puts 'Yes get this item'
      end    
      render_order_items(user)
    end
  end

  private 

  def render_order_items(user)
    render json: user, include: {
        owned_items: {
            include: {
              product: {
                  include: [:base_product]
              }
            }
        }
    }
  end
end
