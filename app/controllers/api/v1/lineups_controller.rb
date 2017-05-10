class API::V1::LineupsController < ApplicationController
  include ViewPermissionConcern

  def index
    render :json => Lineup.all
  end

  def create
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    cortege = Lineup.new(item_params)
    cortege.save!
  end

  def show
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    cortege = Lineup.find(params[:id])
    render :json => cortege
  end

  def update
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    cortege = Lineup.find(params[:id])
    if cortege.update(item_params)
      redirect_to api_v1_cortege_lineups_url(cortege)
    else
      raise 'Unable to update cortege_lineup'
    end
  end

  def destroy
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    cortege = Lineup.find(params[:id])
    cortege.destroy
    head :no_content
  end

  def get_corteges
    render :json => Lineup.where(cortege: true)
  end

  def get_artists
    render :json => Lineup.where(orchestra: true)
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
