class API::V1::UserGroupsController < ApplicationController
  include ViewPermissionConcern

  def index
    require_admin_permission AdminPermission::ALL

    render :json => UserGroupPermissions
  end

  def create
    raise 'Not implemented'
  end

  def update
    if params.has_key? :cortege
      make_user_cortege_member cortege_params
    elsif params.has_key? :case_cortege
      make_user_case_cortege_member case_cortege_params
    elsif params.has_key? :sof_org
      make_user_sof_org_member sof_org_params
    else
      raise 'Invalid params'
    end
  end

  def show
    raise 'Not implemented'
  end

  def destroy
    raise 'Not implemented'
  end



  private

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

  end

  def make_user_cortege_member(params)
    cortege = Cortege.find(params[:user][:cortege_id])
    require_ownership_or_admin_permission cortege, AdminPermission::ALL


    user = User.find_by email: params[:cortege][:email]

    if cortege.has_member?(user)
      raise 'User is already a member of this cortege'
    elsif user.present?
      CortegeMembership.create(
          user_id: user.user_id,
          cortege_id: params[:user][:cortege_id]
      )

      user.usergroup += UserGroupPermissions::CORTEGE_MEMBER
      user.save
    else
      raise "User doesn't exist"
    end
  end

  def make_user_case_cortege_member(params)
    case_cortege = CaseCortege.find(params[:user][:case_cortege_id])
    require_ownership_or_admin_permission case_cortege, AdminPermission::ALL

    user = User.find_by email: params[:case_cortege][:email]

    if case_cortege.has_member?(user)
      raise 'User is already a member of this cortege'
    elsif user.present?
      CortegeMembership.create(
          user_id: user_id,
          case_cortege_id: params[:user][:case_cortege_id]
      )

      user.usergroup += UserGroupPermissions::CORTEGE_MEMBER
      user.save
    else
      raise "User doesn't exist"
    end
  end
end
