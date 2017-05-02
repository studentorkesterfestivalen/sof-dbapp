class API::V1::FaqGroupController < ApplicationController
  include ViewPermissionConcern

  def index
    render :json => FaqGroup.all, except => [:created_at, :updated_at]
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
  end

  def destroy
  end

  private

  def item_params
    params.require(:item).permit(
        :name
    )
  end
end
