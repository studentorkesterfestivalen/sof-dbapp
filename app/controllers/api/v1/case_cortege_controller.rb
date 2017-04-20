class API::V1::CaseCortegeController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    require_admin_permission AdminPermission::LIST_CORTEGE_APPLICATIONS

    render :json => CaseCortege.all, include: [:user]
  end

  def create
    unless current_user.case_cortege.nil?
      raise 'Cannot create another case cortege application'
    end

    cortege = CaseCortege.new(item_params)
    cortege.user = current_user
    cortege.save!

    redirect_to api_v1_case_cortege_url(cortege)
  end

  def show
    cortege = CaseCortege.find(params[:id])
    require_ownership_or_admin_permission cortege, AdminPermission::LIST_CORTEGE_APPLICATIONS

    render :json => cortege, include: [:user]
  end

  def update
    cortege = CaseCortege.find(params[:id])
    params = {}
    if cortege.has_owner? current_user
      params.merge!(item_params.to_h)
    end

    if current_user.has_admin_permission? AdminPermission::APPROVE_CORTEGE_APPLICATIONS
      params.merge!(admin_params.to_h)
    end

    if params.empty?
      # Raise unauthorized error
      require_ownership cortege
    end

    if cortege.update(params)
      redirect_to api_v1_case_cortege_url(cortege)
    else
      raise 'Unable to save cortege'
    end
  end

  def destroy
    cortege = CaseCortege.find(params[:id])
    require_ownership cortege

    cortege.destroy

    head :no_content
  end

  private

  def item_params
    params.require(:item).permit(
        :education,
        :contact_phone,
        :case_cortege_type,
        :group_name,
        :motivation
    )
  end

  def admin_params
    require_admin_permission AdminPermission::APPROVE_CORTEGE_APPLICATIONS

    params.require(:item).permit(
        :approved,
        :status
    )
  end
end
