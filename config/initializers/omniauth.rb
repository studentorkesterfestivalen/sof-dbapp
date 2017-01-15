Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas,
           host:      'login.liu.se',
           login_url: '/cas/login',
           service_validate_url: '/cas/serviceValidate'
end
