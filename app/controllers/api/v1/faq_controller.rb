class API::V1::FaqController < ApplicationController
  include ViewPermissionConcern

  def index
    render :json => Faq.all, include: {
        faq_groups: {
            except => [:created_at, :updated_at]
        },
        except => [:created_at, :updated_at]
    }
  end

  def create
    require_admin_permission AdminPermission::EDITOR

    faq = Faq.new(item_params)
    if faq.save
      render :status => 200, :json => {
          message: 'Successfully created Faq.',
      }
    else
      render :status => 500, :json => {
          message: faq.errors
      }
    end
  end

  def show
  end

  def destroy
    require_admin_permission AdminPermission::EDITOR


    if faq.destroy(params[:id])
      render :status => 200, :json => {
          message: 'Successfully deleted Faq.',
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
        :answer,
        :faq_group_id
    )
  end
end
