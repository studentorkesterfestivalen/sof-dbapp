# Configuration for Kobra integration
Rails.application.config.kobra_api_key = ENV.fetch('KOBRA_API_KEY') {''}

# Ensure Kobra integration is working before starting the server
if ENV['DISABLE_KOBRA_CHECK'].nil?
  require 'kobra'

  puts 'Verifying Kobra API key...'

  kobra = Kobra::Client.new(api_key: Rails.configuration.kobra_api_key)
  kobra.get_student(id: 'patsl736', union: true)

  puts 'Kobra check passed'
else
  puts 'WARNING: Kobra check disabled'
end
