class API::V1::CortegeLineupsController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    render :json => CortegeLineup.all
  end

  def create
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    cortege = CortegeLineup.new(item_params)
    cortege.save!
  end

  def show
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    cortege = CortegeLineup.find(params[:id])
    render :json => cortege
  end

  def update
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    cortege = CortegeLineup.find(params[:id])
    if cortege.update(item_params)
      redirect_to api_v1_cortege_lineups_url(cortege)
    else
      raise 'Unable to update cortege_lineup'
    end
  end

  def destroy
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    cortege = CortegeLineup.find(params[:id])
    cortege.destroy
    head :no_content
  end

  private

  def item_params
    params.require(:item).permit(
      :name,
      :description,
      :image,
      :cortege_type,
      :order
    )
  end

end