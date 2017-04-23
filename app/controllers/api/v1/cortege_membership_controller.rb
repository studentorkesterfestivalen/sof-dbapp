class API::V1::CortegeMembershipController < ApplicationController
  include ViewPermissionConcern

  def index
    require_admin_permission AdminPermission::ALL

    render :json => CortegeMembership.all
  end

  def create
    user = User.find_by email: user_params[:email]
    if user.present? and user != current_user
      begin
        if is_case_cortege_membership?
          case_cortege = CaseCortege.find_by id: cortege_membership_params[:case_cortege_id]
          require_ownership_or_admin_permission case_cortege, AdminPermission::ALL
        else
          cortege = Cortege.find_by id: cortege_membership_params[:cortege_id]
          require_ownership_or_admin_permission cortege, AdminPermission::ALL
        end

        membership = CortegeMembership.new(cortege_membership_params)
        membership.user = user
        membership.user.usergroup |= UserGroupPermission::CORTEGE_MEMBER
        membership.save!
        membership.user.save!

        render :status => '200', :json => {:message => 'Membership created'}
      rescue => error
        render :status => '403', :json => {:status => error}
      end
    else
      render :status => '400', :json => {:status => 'Assigned user does not exists or is self'}
    end
  end

  def show
    raise 'not implemented'
  end

  def destroy
    membership = CortegeMembership.find(params[:id])
    cortege = membership.cortege
    begin
      require_ownership_or_admin_permission cortege, AdminPermission::ALL

      user = User.find(membership.user_id)
      user.usergroup &= ~UserGroupPermission::CORTEGE_MEMBER
      membership.destroy

      render :status => '200', :json => {:message => 'Membership removed.'}
    rescue => error
      puts error
      render :status => '403', :json => {:status => error}
    end
  end

  def show_cortege_members
    cortege = Cortege.find(params[:id])
    require_ownership_or_admin_permission cortege, AdminPermission::LIST_CORTEGE_APPLICATIONS

    cortege_membership = cortege.cortege_memberships

    render :json => cortege_membership, include: [:user]
  end



  private

  def is_case_cortege_membership?
    cortege_membership_params[:case_cortege_id].present?
  end

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

  def item_params
    params.required(:cortege_membership).permit(
        :id,
        :cortege_id
    )
  end
end
