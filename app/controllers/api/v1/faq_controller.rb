class API::V1::FaqController < ApplicationController
  include ViewPermissionConcern

  def index
    render :json => Faq.order(:faq_group_id).all, include: {
        :faq_group => {
            :except => [:created_at, :updated_at]
        }
    }, :except => [:created_at, :updated_at]
  end

  def create
    require_admin_permission AdminPermission::EDITOR

    faq = Faq.new(item_params)
    if faq.save
      render :status => 200, :json => {
          message: 'FAQ skapad.',
      }
    else
      render :status => 500, :json => {
          message: faq.errors
      }
    end
  end

  def show
    require_admin_permission AdminPermission::EDITOR

    faq = Faq.find(params[:id])
    if faq.present?
      render :json => faq, include: {
          :faq_group => {
              :except => [:created_at, :updated_at]
          }
      }, :except => [:created_at, :updated_at]
    else
      render :status => 500, :json => {
          message: 'FAQ hittades ej.'
      }
    end
  end

  def update
    require_admin_permission AdminPermission::EDITOR

    Faq.update(params[:id], item_params)
    render :status => 200, :json => {
        message: 'FAQ uppdaterad.'
    }
  end


  def destroy
    require_admin_permission AdminPermission::EDITOR

    faq = Faq.destroy(params[:id])
    if faq.destroyed?
      render :status => 200, :json => {
          message: 'FAQ togs bort.',
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
        :question,
        :question_eng,
        :answer,
        :answer_eng,
        :faq_group_id
    )
  end
end
