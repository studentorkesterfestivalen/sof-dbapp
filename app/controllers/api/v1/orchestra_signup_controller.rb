class API::V1::OrchestraSignupController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    require_admin_permission AdminPermission::LIST_ORCHESTRA_SIGNUPS

    render :json => OrchestraSignup.all
  end

  def create
    unless current_user.orchestra_signup.nil?
      raise 'Cannot sign up for another orchestra'
    end

    orchestra = Orchestra.find_by(code: params[:item][:code].downcase, allow_signup: true)
    if orchestra.nil?
      raise 'Unable to find matching orchestra'
    end

    signup = OrchestraSignup.new(item_params)
    signup.user = current_user
    signup.orchestra = orchestra
    signup.user.usergroup |= UserGroupPermission::ORCHESTRA_MEMBER

    if OrchestraSignup.include_late_registration_fee? and Date.today < DateTime.parse('2017-04-30 22:00')
      signup.is_late_registration = true
    end

    signup.save!
    signup.user.save!

    redirect_to api_v1_orchestra_signup_url(signup)
  end

  def show
    signup = OrchestraSignup.find(params[:id])
    require_membership_or_admin_permission signup, AdminPermission::LIST_ORCHESTRA_SIGNUPS

    render :json => signup, include: [:orchestra, :orchestra_articles, :orchestra_ticket, :orchestra_food_ticket, :special_diets], methods: :total_cost
  end

  def update
    orchestra_signup = OrchestraSignup.find(params[:id])
    require_ownership orchestra_signup

    if orchestra_signup.update(item_params)
      redirect_to api_v1_orchestra_signup_url(orchestra_signup)
    else
      raise 'Unable to save signup'
    end
  end

  def destroy
    orchestra_signup = OrchestraSignup.find(params[:id])
    require_ownership orchestra_signup

    orchestra_signup.destroy

    head :no_content
  end

  def verify_code
    orchestra = Orchestra.find_by(code: params[:code].downcase, allow_signup: true)
    if orchestra.nil?
      raise 'Unable to find matching orchestra'
    end

    render :json => orchestra, only: [:name, :dormitory]
  end

  private

  def item_params
    params.require(:item).permit(
        :dormitory,
        :active_member,
        :consecutive_10,
        :attended_25,
        :instrument_size,
        :other_performances,
        orchestra_ticket_attributes: [
            :kind
        ],
        orchestra_food_ticket_attributes: [
            :kind,
            :diet
        ],
        orchestra_articles_attributes: [
            :kind,
            :data
        ],
        special_diets_attributes: [
            :name
        ]
    )
  end
end
