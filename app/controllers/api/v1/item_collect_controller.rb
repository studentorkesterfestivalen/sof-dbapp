require 'kobra'

class API::V1::ItemCollectController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def find
    require_admin_permission AdminPermission::TICKETER

    user = find_user_from_query
    if user.present?
      render :status => '200', :json => {:user_id => user.id}
    else
      render :status => '404', :json => {:message => 'Användaren kunde inte hittas'}
    end
  end

  def show
    require_admin_permission AdminPermission::TICKETER

    user = User.find_by id: params[:id]

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

  private

  # Ordered with least complexity first
  def find_user_from_query
    find_user_from :liu_id or
    find_user_from :email or
    find_user_from :card
  end

  def find_user_from(source)
    case source
      when :card
        find_user_from_kobra params[:query]
      when :liu_id
        User.find_by nickname: params[:query]
      when :email
        User.find_by email: params[:query]
      else
        nil
    end
  end

  def find_user_from_kobra(card_id)
    begin
      kobra = Kobra::Client.new(api_key: Rails.configuration.kobra_api_key)
      response = kobra.get_student(id: card_id)
      liu_id = response[:liu_id]

      User.find_by nickname: liu_id
    rescue
      nil
    end
  end
end
