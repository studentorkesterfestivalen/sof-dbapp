# require 'kobra'
#
# # Configuration for Kobra integration
# # Rails.application.config.kobra_api_key = ENV.fetch('KOBRA_API_KEY') {''}
#
# # Arbitrary LiU student used to verify Kobra functionality
# TEST_STUDENT = 'patsl736'
#
#
# begin
#   kobra = Kobra::Client.new(api_key: Rails.configuration.kobra_api_key)
#   kobra.get_student(id: TEST_STUDENT, union: true)
# rescue Kobra::Client::AuthError
#   # API key is invalid, please configure another one as this is a permanent issue
#   FaultReport.send('Failed to authenticate with Kobra')
# rescue
#   # Unable to communicate with Kobra at the moment, this could very well be a temporary issue
#   FaultReport.send('Failed to connect to Kobra')
# end
