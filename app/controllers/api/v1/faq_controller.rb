class API::V1::FaqController < ApplicationController
  include ViewPermissionConcern


  def index
    render :json => Faq.all, include: {
        faq_groups: {
            except => [:created_at, :updated_at]
        }
    }
  end

  def create
    require_admin_permission AdminPermission::
  end

  def show
  end

  def destroy
  end

  private

  def item_params
    params.require(:item).permit(
        :question,
        :answer,
        :faq_group_id
    )
  end
end
