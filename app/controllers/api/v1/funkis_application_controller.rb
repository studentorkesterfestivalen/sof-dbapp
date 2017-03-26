class API::V1::FunkisApplicationController < ApplicationController
  before_action :authenticate_user!

  include ViewPermissionConcern

  def index
    raise 'Not implemented'
  end

  def create
    application = FunkisApplication.new(application_params)
    application.user = current_user

    application.save!
    send_email_on_completion(application)

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
      send_email_on_completion(application)
      redirect_to api_v1_funkis_application_url(application)
    else
      head :bad_request
    end
  end

  def delete
    raise 'Not implemented'
  end

  private

  def send_email_on_completion(application)
    if application.completed?
      InformationMailer.funkis_confirmation(application).deliver_now
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
            :funkis_shift_id
        ]
    )
  end
end
