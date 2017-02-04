# Configuration for Kobra integration
Rails.application.config.kobra_api_key = ENV.fetch('KOBRA_API_KEY') {''}
