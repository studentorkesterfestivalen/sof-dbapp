class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # config.middleware.insert_before 0, Rack::Cors do
  #   allow do
  #     origins '*'
  #     resource '*', headers: :any, methods: [:get, :post, :options]
  #   end
  # end



  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:display_name])
  end
end
