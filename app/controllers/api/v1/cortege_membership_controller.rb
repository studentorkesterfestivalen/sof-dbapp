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
end
