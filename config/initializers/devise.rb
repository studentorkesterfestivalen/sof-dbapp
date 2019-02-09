Devise.setup do |config|
  # The e-mail address that mail will appear to be sent from
  # If absent, mail is sent from "please-change-me-at-config-initializers-devise@example.com"
  config.mailer_sender = 'noreply@sof.lintek.liu.se'

  # If using rails-api, you may want to tell devise to not use ActionDispatch::Flash
  # middleware b/c rails-api does not include it.
  # See: http://stackoverflow.com/q/19600905/806956
  config.navigational_formats = [:json]



  config.secret_key = ENV['DEVISE_SECRET_KEY'] if Rails.env.production?
  #'a30b6a63b1a9f3ccff34f29acb1a2bc7ce43fc55e4e00804c27f7b9ff754c02239254d87c537e646e9ad195cff375048e1c45f7b0a1538b5999c7609beeed4ee'
  #
  #
end
