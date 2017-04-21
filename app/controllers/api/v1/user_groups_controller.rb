class API::V1::UserGroupsController < ApplicationController
  include ViewPermissionConcern

  def index
    require_admin_permission AdminPermission::ALL

    render :json => UserGroupPermissions
  end

  def update
    if params.has_key? :cortege
      make_user_cortege_member cortege_params
    elsif params.has_key? :case_cortege
      make_user_case_cortege_member case_cortege_params
    else
      raise 'Invalid params'
    end
  end



  private

  def cortege_params
    params.require(:cortege).permit(
        :cortege_id,
        # TODO: Should be email
        :user_id)
  end

  def case_cortege_params
    params.require(:case_cortege).permit(
        :case_cortege_id,
        # TODO: Should be email
        :user_id)
  end

  def make_user_cortege_member(params)
    cortege = Cortege.find(params[:user][:cortege_id])
    require_ownership_or_admin_permission cortege, AdminPermission::ALL

    if cortege.has_member?(params[:user][:user_id])
      raise 'User is already a member of this cortege'
    else
      CortegeMembership.create(
          user_id: params[:user][:user_id],
          cortege_id: params[:user][:cortege_id]
      )
    end
  end

  def make_user_case_cortege_member(params)
    case_cortege = CaseCortege.find(params[:user][:case_cortege_id])
    require_ownership_or_admin_permission case_cortege, AdminPermission::ALL

    if case_cortege.has_member?(params[:user][:user_id])
      raise 'User is already a member of this cortege'
    else
      CortegeMembership.create(
          user_id: params[:user][:user_id],
          case_cortege_id: params[:user][:case_cortege_id]
      )
    end
  end


end
