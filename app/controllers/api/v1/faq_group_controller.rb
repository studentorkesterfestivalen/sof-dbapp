class API::V1::FaqGroupController < ApplicationController
  include ViewPermissionConcern

  def index
    render :json => FaqGroup.order(:id).all, :include => {
        :faqs => {
            :except => [:created_at, :updated_at]
        },
    }, :except => [:created_at, :updated_at]
  end

  def create
    require_admin_permission AdminPermission::EDITOR

    faq_group = FaqGroup.new(item_params)
    if faq_group.save
      render :status => 200, :json => {
          message: 'Successfully created Faq-group.',
      }
    else
      render :status => 500, :json => {
          message: faq_group.errors
      }
    end
  end

  def show
    require_admin_permission AdminPermission::EDITOR

    faq_group = FaqGroup.find(params[:id])
    if faq_group.present?
      render :json => faq_group, :except => [:created_at, :updated_at]
    else
      render :status => 500, :json => {
          message: 'FAQ-Grupp hittades ej.'
      }
    end
  end

  def update
    require_admin_permission AdminPermission::EDITOR

    FaqGroup.update(params[:id], item_params)
    render :status => 200, :json => {
        message: 'FAQ-grupp uppdaterad'
    }
  end

  def destroy
    require_admin_permission AdminPermission::EDITOR

    faq_group = FaqGroup.destroy(params[:id])
    if faq_group.destroyed?
      render :status => 200, :json => {
          message: 'FAQ-gruppen togs bort.',
      }
    else
      render :status => 500, :json => {
          message: faq.errors
      }
    end
  end

  private

  def item_params
    params.require(:item).permit(
        :name,
        :name_eng
    )
  end
end
