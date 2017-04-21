class API::V1::CortegeMembershipController < ApplicationController
  include ViewPermissionConcern

  def index
    require_admin_permission AdminPermission::ALL

    render :json => CortegeMembership.all
  end

  def create
    raise 'Not implemented'
  end

  def modify_membership
    if params.has_key? :all
      raise 'Not implemented'
    elsif params.has_key? :cortege
      modify_cortege_membership cortege_params, true
    elsif params.has_key? :case_cortege
      modify_case_cortege_membership case_cortege_params, true
    elsif params.has_key? :sof_org
      raise 'Not implemented'
    else
      raise 'Invalid params'
    end
  end

  def show
    raise 'Not implemented'
  end

  def destroy
    if params.has_key? :cortege
      modify_cortege_membership cortege_params, false
    elsif params.has_key? :case_cortege
      modify_case_cortege_membership case_cortege_params, false
    else
      raise 'Invalid params'
    end
  end



  private

  def all_groups_params
    params.require(:all).permit(
        :email
    )
  end

  def sof_org_params
    params.require(:sof_org).permit(
        :email
    )
  end

  def cortege_params
    params.require(:cortege).permit(
        :cortege_id,
        :email)
  end

  def case_cortege_params
    params.require(:case_cortege).permit(
        :case_cortege_id,
        :email)
  end

  def make_user_sof_org_member(params)
    require_admin_permission AdminPermission::ALL

    user = User.find_by email: params[:sof_org][:email]

    if user.present?
      user.usergroup |= UserGroupPermissions::SOF_ORGANISATION
    else
      raise "User doesn't exist"
    end
  end

  def modify_cortege_membership(params, add)
    cortege = Cortege.find(params[:user][:cortege_id])
    require_ownership_or_admin_permission cortege, AdminPermission::ALL

    user = User.find_by email: params[:cortege][:email]
    unless user.present?
      raise "User doesn't exist"
    end

    if add
      CortegeMembership.add_cortege_membership(user, cortege)
    else
      CortegeMembership.remove_cortege_membership(user, cortege)
    end
  end


  def modify_case_cortege_membership(params, add)
    case_cortege = CaseCortege.find(params[:user][:case_cortege_id])
    require_ownership_or_admin_permission case_cortege, AdminPermission::ALL

    user = User.find_by email: params[:case_cortege][:email]
    unless user.present?
      raise "User doesn't exist"
    end

    if add
      CortegeMembership.add_case_cortege_membership(user, case_cortege)
    else
      CortegeMembership.remove_case_cortege_membership(user, case_cortege)
    end
  end
end
