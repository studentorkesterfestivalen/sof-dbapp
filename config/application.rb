require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load environment variables for development and testing only
if Rails.env.development? or Rails.env.test?
  Dotenv::Railtie.load
end

module SofDbapp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Session storage is required for Omniauth (CAS) authentication.
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # Fallback to English locale when Swedish translation is missing.
    config.i18n.fallbacks = [:en]
  end
end

config.generators do |g|
  g.test_framework :rspec,
                   :fixtures => true,
                   :view_specs => false,
                   :helper_specs => false, #change to true later
                   :routing_specs => false, #change to true later
                   :controller_specs => true,
                   :request_specs => true
  g.fixture_replacement :factory_girl, :dir => "spec/factories"
end
