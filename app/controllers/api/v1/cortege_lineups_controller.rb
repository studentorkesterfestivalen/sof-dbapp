class API::V1::CortegeLineupsController < ApplicationController
  include ViewPermissionConcern

  def index
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

  def get_corteges
    render :json => CortegeLineup.where(cortege: true)
  end

  def get_artists
    render :json => CortegeLineup.where(orchestra: true)
  end

  private

  def item_params
    params.require(:item).permit(
      :name,
      :description,
      :image,
      :order,
      :orchestra,
      :ballet,
      :cortege
    )
  end

end
