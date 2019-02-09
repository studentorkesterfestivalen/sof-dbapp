require_relative 'boot'

require 'csv'
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


    # Remember to change origins when not running on localhost! #
    config.middleware.insert_before 0, Rack::Cors do
      allow do
      origins '*'
      resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options, :patch], :expose => ['uid', 'client', 'expiry', 'access-token', 'token-type']
      end
    end


    # Fallback to English locale when Swedish translation is missing.
    config.i18n.fallbacks = [:en]



  end
end
