class API::V1::FunkisApplicationController < ApplicationController
  before_action :authenticate_user!

  include ViewPermissionConcern

  def index
    require_admin_permission AdminPermission::LIST_FUNKIS_APPLICATIONS

    categories = FunkisCategory.includes(funkis_shifts: [:funkis_shift_applications])
    render json: categories, include: {
      funkis_shifts: {
          methods: [
              :completed_applications_count
          ]
      }
    }
  end

  def create
    disable_feature from: '2017-05-04'

    application = FunkisApplication.new(application_params)
    application.user = current_user

    application.save!
    attempt_to_finalize_application(application)

    redirect_to api_v1_funkis_application_url(application)
  end

  def show
    application = FunkisApplication.find(params[:id])
    require_ownership application

    render :json => application, include: [
        funkis_shift_applications: {
            include: [
                funkis_shift: {
                    except: [
                        :maximum_workers
                    ]
                }
            ]
        }
    ]
  end

  def update
    application = FunkisApplication.find(params[:id])
    require_ownership application

    if application.update(application_params)
      attempt_to_finalize_application(application)
      redirect_to api_v1_funkis_application_url(application)
    else
      remove_unavailable_shifts application
      head :bad_request
    end
  end

  def destroy
    require_admin_permission AdminPermission::ALL

    application = FunkisApplication.find(params[:id])
    reset_funkis_parameters application
    application.destroy!

    head :no_content
  end


  private

  def reset_funkis_parameters(application)
    if application.user.rebate_given.present?
      application.user.rebate_balance = 0
      application.user.rebate_given = false
      application.user.usergroup &= ~UserGroupPermission::FUNKIS
      application.user.save!
    end
  end

  def attempt_to_finalize_application(application)
    if application.completed?
      total_points = calculate_accrued_funkis_points application
      rebate = points_to_rebate total_points

      current_user.usergroup |= UserGroupPermission::FUNKIS

      unless current_user.rebate_given
        current_user.rebate_balance = rebate
        current_user.rebate_given = true
      end

      current_user.save!

      InformationMailer.funkis_confirmation(application).deliver_now
    end
  end

  def points_to_rebate(points)
    case points
      when 50
        60
      when 100
        150
      when 150
        240
      else
        0
    end
  end

  def calculate_accrued_funkis_points(application)
    total_points = 0
    application.funkis_shift_applications.each do |shift_application|
      total_points += shift_application.funkis_shift.points
      if total_points > 150
        total_points = 150
      end
    end
    total_points
  end

  def remove_unavailable_shifts(application)
    application.funkis_shift_applications.each do |shift|
      unless shift.funkis_shift.available?
        shift.destroy
      end
    end
  end

  def application_params
    if params[:item] and params[:item][:terms_agreed]
      extra_params = {terms_agreed_at: DateTime.now}
    else
      extra_params = {}
    end

    filtered_params.merge(extra_params)
  end

  def filtered_params
    params.require(:item).permit(
        :ssn,
        :phone,
        :tshirt_size,
        :allergies,
        :drivers_license,
        :presale_choice,
        funkis_shift_applications_attributes: [
            :id,
            :funkis_shift_id,
            :_destroy
        ]
    )
  end
end
