class API::V1::OrchestraSignupController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    require_permission LIST_ORCHESTRA_SIGNUPS

    render :json => OrchestraSignup.all
  end

  def create
    orchestra = Orchestra.find_by(code: params[:item][:code].downcase, allow_signup: true)
    if orchestra.nil?
      raise 'Unable to find matching orchestra'
    end

    signup = OrchestraSignup.new(item_params)
    signup.user = current_user
    signup.orchestra = orchestra
    signup.save!

    redirect_to api_v1_orchestra_signup_url(signup)
  end

  def show
    signup = OrchestraSignup.find(params[:id])
    require_ownership signup

    render :json => signup, include: [:orchestra, :orchestra_articles, :orchestra_ticket, :orchestra_food_ticket]
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

  private

  def item_params
    params.require(:item).permit(
        :dormitory,
        :active_member,
        :consecutive_10,
        :attended_25,
        :instrument_size,
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
        ]
    )
  end
end
