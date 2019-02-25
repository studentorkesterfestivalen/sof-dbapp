class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:display_name])
  end

  def set_locale
    if !request.header["locale"].nil?
      I18n.locale = request.headers["locale"]
    else 
      I18n.locale = 'sv'
    end
  end
end
