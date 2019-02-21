class API::V1::OrchestraSignupController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    #Returns all signups for the user making the request,
    render :json => current_user.orchestra_signup.all, include: [:orchestra, :orchestra_articles, :orchestra_ticket, :orchestra_food_ticket, :special_diets]
  end

  def all
    require_admin_permission AdminPermission::ORCHESTRA_ADMIN
    #render :json => OrchestraSignup.all

    orchestra_singups = OrchestraSignup.all.order(:orchestra_signup_id)
    render :plain => CSVExport.render_csv(orchestra_signups, Formats::OrchestraSignupFormat)
  end

  def create

    # If a user only belongs to one orchestra
    # unless current_user.orchestra_signup.nil?
    #   raise 'Cannot sign up for another orchestra'
    # end

    orchestra = Orchestra.find_by(code: params[:code].downcase, allow_signup: true)
    if orchestra.nil?
      raise 'Unable to find matching orchestra'
    end

    #unless orchestra.orchestra_signups.find_by(user_id: current_user.id).nil?
    #  raise 'Can not register to same orchestra twice'
    #end
    # Bad practice to remove directly from params, did not find any other way
    unless current_user.orchestra_signup.nil?
      params[:item].delete :orchestra_ticket_attributes
      params[:item].delete :orchestra_food_ticket_attributes
      params[:item].delete :orchestra_articles_attributes
      params[:item].delete :special_diets_attributes
      params[:item].delete :dormitory
      params[:item].delete :consecutive_10
      params[:item].delete :consecutive_25
    end

    signup = OrchestraSignup.new(item_params)
    signup.user = current_user
    signup.orchestra = orchestra
    signup.user.usergroup |= UserGroupPermission::ORCHESTRA_MEMBER


    # if OrchestraSignup.include_late_registration_fee? and DateTime.now < DateTime.parse('2019-04-30 22:00')
    #   signup.is_late_registration = true
    # end

    signup.save!
    signup.user.save!

    p signup.total_cost

    render :json => signup
    # redirect_to api_v1_orchestra_signup_url(signup)
  end

  def show
    signup = OrchestraSignup.find(params[:id])
    require_membership_or_admin_permission signup, AdminPermission::ORCHESTRA_ADMIN

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
    print params[:data]
    orchestra = Orchestra.find_by(code: params[:code].downcase, allow_signup: true)
    if orchestra.nil?
      raise 'Unable to find matching orchestra'
    end

    # First signup is used to minimize the number of questions
    # that need to be filled in on the front end if false.
    first_signup = current_user.orchestra_signup.empty?

    # Used to reroute to an already submitted signup in frontend if true
    double_signup = !orchestra.orchestra_signups.find_by(user_id: current_user.id).nil?

    #Fix later: Filter out data from the return orchestra object
    #render :json => orchestra, only: [:name, :dormitory, :arrival_date]
    render :json => {:orchestra => orchestra, :double_signup => double_signup ,:first_signup => first_signup}

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
        :orchestra_role,
        :arrival_date,
        orchestra_ticket_attributes: [
            :kind
        ],
        orchestra_food_ticket_attributes: [
            :kind
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
