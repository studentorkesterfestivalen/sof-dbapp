class API::V1::FaqGroupController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

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
          message: 'FAQ-Group not found.'
      }
    end
  end

  def destroy
  end

  private

  def item_params
    params.require(:item).permit(
        :name,
        :name_eng
    )
  end
end
