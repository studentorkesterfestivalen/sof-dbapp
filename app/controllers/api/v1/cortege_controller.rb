class API::V1::CortegeController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS

    update_paid_flag

    render :json => Cortege.all, include: [:user]
  end

  def create
    disable_feature from: '2017-02-27'

    unless current_user.cortege.nil?
      raise 'Cannot create another cortege application'
    end

    cortege = Cortege.new(item_params)
    cortege.user = current_user
    cortege.save!

    redirect_to api_v1_cortege_url(cortege)
  end

  def show
    cortege = Cortege.find(params[:id])
    require_ownership_or_admin_permission cortege, AdminPermission::LIST_CORTEGE_APPLICATIONS

    render :json => cortege, include: [:user]
  end

  def update
    cortege = Cortege.find(params[:id])
    params = {}
    if cortege.has_owner? current_user
      params.merge!(item_params.to_h)
    end

    if current_user.has_admin_permission? AdminPermission::APPROVE_CORTEGE_APPLICATIONS
      params.merge!(admin_params.to_h)
    end

    if params.empty?
      # Raise unauthorized error
      require_ownership cortege
    end

    if cortege.update(params)
      redirect_to api_v1_cortege_url(cortege)
    else
      raise 'Unable to save cortege'
    end
  end

  def destroy
    cortege = Cortege.find(params[:id])
    require_ownership cortege

    cortege.destroy

    head :no_content
  end

  private

  def update_paid_flag
    corteges = Cortege.all
    corteges.each do |cortege|
      if cortege.user.present?
        cortege.user.purchased_items.each do |item|
          case item.product.base_product.name
            when 'Makrobygge', 'Microbygge', 'Fribygge'
              cortege.paid = true
              cortege.save
          end
        end
      end
    end
  end

  def item_params
    params.require(:item).permit(
        :name,
        :student_association,
        :participant_count,
        :cortege_type,
        :contact_phone,
        :idea,
        :comments
    )
  end

  def admin_params
    require_admin_permission AdminPermission::APPROVE_CORTEGE_APPLICATIONS

    params.require(:item).permit(
        :approved,
        :status
    )
  end
end
