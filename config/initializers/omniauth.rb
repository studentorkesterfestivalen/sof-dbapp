# Load LiU-ID fix
require 'ext/cas'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas,
           host:      'login.liu.se',
           login_url: '/cas/login',
           service_validate_url: '/serviceValidate'
end
