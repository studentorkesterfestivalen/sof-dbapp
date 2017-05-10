class API::V1::LineupsController < ApplicationController
  include ViewPermissionConcern

  def index
    render :json => Lineup.all
  end

  def create
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    lineup = Lineup.new(item_params)
    lineup.save!
  end

  def show
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    lineup = Lineup.find(params[:id])
    render :json => lineup
  end

  def update
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    lineup = Lineup.find(params[:id])
    if lineup.update(item_params)
      redirect_to api_v1_lineups_url(lineup)
    else
      raise 'Unable to update lineup'
    end
  end

  def destroy
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS
    lineup = Lineup.find(params[:id])
    lineup.destroy
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
