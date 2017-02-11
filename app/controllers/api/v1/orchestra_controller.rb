class API::V1::OrchestraController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    require_permission Permission::LIST_ORCHESTRA_SIGNUPS

    render :json => Orchestra.all, include: [:user]
  end

  def create
    unless current_user.orchestra.nil?
      raise 'Cannot create another orchestra'
    end

    orchestra = Orchestra.new(item_params)
    orchestra.user = current_user
    orchestra.save!

    redirect_to api_v1_orchestra_url(orchestra)
  end

  def show
    orchestra = Orchestra.find(params[:id])
    require_ownership_or_permission orchestra, Permission::LIST_ORCHESTRA_SIGNUPS

    render :json => orchestra, include: [orchestra_signups: {include: [:user], methods: :total_cost}]
  end

  def update
    orchestra = Orchestra.find(params[:id])
    require_ownership orchestra

    unless params[:item][:code].nil?
      # Don't allow setting a custom access code as it may be insecure
      orchestra.generate_new_access_code
      unless orchestra.save!
        raise 'Unable to generate new access code'
      end
    end

    if orchestra.update(item_params)
      redirect_to api_v1_orchestra_url(orchestra)
    else
      raise 'Unable to save orchestra'
    end
  end

  def destroy
    orchestra = Orchestra.find(params[:id])
    require_ownership orchestra

    orchestra.destroy

    head :no_content
  end

  private

  def item_params
    params.require(:item).permit(
        :name,
        :orchestra_type,
        :allow_signup,
        :dormitory
    )
  end
end
