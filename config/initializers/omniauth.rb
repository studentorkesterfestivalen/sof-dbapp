# Load LiU-ID fix
require 'ext/cas'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas,
           host:      'login.it.liu.se',
           login_url: '/idp/profile/cas/login',
           service_validate_url: '/idp/profile/cas/serviceValidate'
end
