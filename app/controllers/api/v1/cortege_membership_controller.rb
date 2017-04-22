class API::V1::CortegeMembershipController < ApplicationController
  include ViewPermissionConcern

  def index
    require_admin_permission AdminPermission::ALL

    render :json => CortegeMembership.all
  end

  def create
    user = User.find_by email: user_params[:email]
    unless user.present?
      render :status => '400', :json => {:status => 'User does not exist'}.to_json
    end

    if cortege_membership_params[:case_cortege_id].present?
      case_cortege = CaseCortege.find_by id: cortege_membership_params[:case_cortege_id]
      require_ownership_or_admin_permission case_cortege, AdminPermission::ALL
    else
      cortege = Cortege.find_by id: cortege_membership_params[:cortege_id]
      require_ownership_or_admin_permission cortege, AdminPermission::ALL
    end

    membership = CortegeMembership.new(cortege_membership_params)
    membership.user_id = user.id
    membership.save!

    render :status => '200', :json => {:message => 'Membership created'}.to_json
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
    raise 'not implemented'
  end

  def destroy
    raise 'not implemented'
  end



  private

  def cortege_membership_params
    params.require(:cortege_membership).permit(
        :cortege_id,
        :case_cortege_id
    )
  end

  def user_params
    params.required(:user).permit(
        :email
    )
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
