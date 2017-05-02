class API::V1::CortegeMembershipController < ApplicationController
  include ViewPermissionConcern

  def index
    require_admin_permission AdminPermission::ALL

    render :json => CortegeMembership.all
  end

  def create
    user = User.find_by email: user_params[:email].downcase
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

        render :status => '200', :json => {:message => 'Medlemmen tillagd.'}
      rescue => error
        render :status => '403', :json => {:message => error}
      end
    else
      render :status => '400', :json => {:message => 'Den givna användaren finns ej, alltså har den aldrig loggat in på hemsidan innan. Eller så angav du dig själv.'}
    end
  end

  def show
    raise 'not implemented'
  end

  def destroy
    membership = CortegeMembership.find(params[:id])
    if membership.cortege.present?
      cortege = membership.cortege
    else
      cortege = membership.case_cortege
    end

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

  def show_case_cortege_members
    case_cortege = CaseCortege.find(params[:id])
    require_ownership_or_admin_permission case_cortege, AdminPermission::LIST_CORTEGE_APPLICATIONS

    case_cortege_memberships = case_cortege.cortege_memberships

    render :json => case_cortege_memberships, include: [:user]
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
