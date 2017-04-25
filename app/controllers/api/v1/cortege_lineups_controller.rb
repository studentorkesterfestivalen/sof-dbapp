class API::V1::CortegeLineupsController < ApplicationController
  include ViewPermissionConcern

  def index
    render :json => CortegeLineup.all
  end

  def create
    puts(" DBAPP create --------------------------------------------------------------")
    cortege = CortegeLineup.new(item_params)
    cortege.save!
    #redirect_to api_v1_cortege_lineup_url()
  end

  def show
    cortege = CortegeLineup.find(params[:id])

    render :json => cortege
  end

  def update
    cortege = CortegeLineup.find(params[:id])

    if cortege.update(params)
      redirect_to api_v1_cortege_lineups_url(cortege)
    else
      raise 'Unable to save cortege'
    end
  end

  def destroy
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
        :cortege_type
    )
  end

end
