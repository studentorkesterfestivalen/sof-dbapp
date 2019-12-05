source 'https://rubygems.org'

# Enable use of .env file to specify environment variables for development
gem 'dotenv-rails', :groups => [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use PostgreSQL for Heroku database
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', require: 'rack/cors'

# Kobra integration to verify student union membership
# gem 'kobra_client', git: 'https://github.com/studentorkesterfestivalen/kobra_client.git'

# Stripe payments API
gem 'stripe'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Use sqlite3 as the database for Active Record when developing and testing
  #gem 'sqlite3', '~> 1.3', '< 1.4'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring', group: :development
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
end

group :test do
  gem 'timecop'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Authentication
gem 'omniauth'
gem 'devise'
gem 'devise_token_auth', git: 'https://github.com/NaabZer/devise_token_auth.git'
gem 'omniauth-cas'

# Ruby version for Heroku
ruby '2.6.0'
