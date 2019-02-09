DeviseTokenAuth.setup do |config|
  # By default the authorization headers will change after each request. The
  # client is responsible for keeping track of the changing tokens. Change
  # this to false to prevent the Authorization header from changing after
  # each request.
  config.change_headers_on_each_request = false

  # By default this value is expected to be sent by the client so that the API
  # knows where to redirect users after successful email confirmation. If this
  # param is set, the API will redirect to this value when no value is provided
  # by the client.
  config.default_confirm_success_url = 'https://www.sof.lintek.liu.se/'

  # Disabled to allow password reset.
  # TODO: Uncomment when following issue is resolved
  # https://github.com/lynndylanhurley/devise_token_auth/issues/481
  # config.check_current_password_before_update = :password
end
