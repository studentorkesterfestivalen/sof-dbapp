class API::V1::PaymentController < ApplicationController
  include ViewPermissionConcern

  #before_action :authenticate_user!
  require 'rest-client'
  # require 'base64'

  def charge

    # Added

    order = "hej"
    created_charge = create_charge!(order)
    # Avoid sending the session_id to the front end,
    return_copy = created_charge
    return_copy.delete("session_id")
    render :status => '200', :json => return_copy
    #Add
  #   order = current_user.cart.create_order
  #   if order.purchasable?
  #     if order.amount == 0
  #       order.complete_free_checkout!
  #     else
  #       created_charge = create_charge!(order)
  #       order.complete! created_charge
  #     end
  #     current_user.cart.empty!
  #
  #     redirect_to api_v1_order_url(order)
  #   else
  #     head :not_acceptable
  #   end
  # rescue Stripe::CardError => e
  #   raise e.message
  end

  private

  def create_charge!(order)
    #  response = RestClient::Request.execute(
    #   method: :post,
    #   url: ENV['KLARNA_API_ENDPOINT']+"/payments/v1/sessions",
    # #    user: 'PK08073_6dac7ed84a69', password: 'BK39HKnuiBEuEjH3',
    #   user: ENV['KLARNA_API_USERNAME'], password: ENV['KLARNA_API_PASSWORD'],
    #   headers: {content_type: 'json', accept: :json},
    #   payload: {
    #     "order_id": "231234asdf",
    #     "status": "CHECKOUT_INCOMPLETE",
    #     "purchase_country": "SE",
    #     "purchase_currency": "sek",
    #     # "locale": "sv-SE",
    #     "order_amount": 0,
    #     # "order_tax_amount": 0,
    #     "order_lines": [{
    #       "type": "physical",
    #       # "reference": "19-402",
    #       "name": "Battery Power Pack",
    #       "quantity": 0,
    #       "unit_price": 0,
    #       # "tax_rate": 0,
    #       "total_amount": 0,
    #       # "total_discount_amount": 0,
    #       # "total_tax_amount": 0
    #     }]
    #   })
      require 'uri'
      require 'net/http'
      require 'json'

      url = URI(ENV['KLARNA_API_ENDPOINT']+"/payments/v1/sessions")
      http = Net::HTTP.new(url.host, url.port)
      # Required because KLARNA API only accepts https requests
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = 'application/json'
      # Base64::encode64 magically creates a \n for some weird reason? Use Base64::strict_encode64
      request["Authorization"] = 'Basic '+Base64.strict_encode64(ENV['KLARNA_API_USERNAME']+':'+ENV['KLARNA_API_PASSWORD'])
      request["cache-control"] = 'no-cache'
      request.body = "{
                        \"purchase_country\": \"SE\",
                        \"purchase_currency\" : \"sek\",
                        \"order_amount\": 0,
                        \"order_lines\":
                          [
                            {
                              \"type\" : \"physical\",
                              \"quantity\": 0,
                              \"total_amount\": 0,\"unit_price\": 0,
                              \"name\" : \"Initial\"
                            }
                          ],
                        \"payment_method_categories\": [
                          {
                            \"asset_urls\": {
                              \"descriptive\": \"https://cdn.klarna.com/1.0/shared/image/generic/badge/en_us/pay_later/descriptive/pink.svg\",
                              \"standard\": \"https://cdn.klarna.com/1.0/shared/image/generic/badge/en_us/pay_later/standard/pink.svg\"
                            },
                            \"identifier\": \"pay_now\",
                            \"name\": \"Pay Now\"
                          }
                        ],
                        \"status\":\"complete\"
                      }"

      response = http.request(request)

    #  if response.code === 200
        result = JSON.parse(response.body)
        puts result

      return result
    #  end
  #    puts response.read_body


#       "order_id" : "231234asdf",
# "status": "CHECKOUT_INCOMPLETE",
# "purchase_country": "SE",
# "purchase_currency" : "sek",
# "order_amount": 0,
# "order_lines":
#   [
#   {	"type" : "physical",
#     "quantity": 0,
#     "total_amount": 0,
#     "unit_price": 0,
#     "name" : "Initial"
#   }
#   ]

    #   headers: {content_type: 'application/json'})
    #   # headers: {Authorization: "Basic " + Base64.encode64("PK08073_6dac7ed84a69:BK39HKnuiBEuEjH3"),
    #             # content_type: 'application/json'}
    #   rescue => e
    #     logger.warn "Unable to do request, will ignore: #{e}"
    #
    # RestClient::Request.execute(url: 'https://api.playground.klarna.com/payments/v1/sessions',\
    #    method: :post,
    #    headers:{Authorization: "Basic #{Base64.encode64('PK08073_6dac7ed84a69:BK39HKnuiBEuEjH3')}",  content_type: 'application/json'})
    # response = RestClient.get('https://www.google.se/', headers={})
    # print response
    #print (Base64.encode64('PK08073_6dac7ed84a69:BK39HKnuiBEuEjH3'))
    #  RestClient.post('https://api.playground.klarna.com/payments/v1/sessions', headers = Authorization: "Basic #{Base64.encode64('PK08073_6dac7ed84a69:BK39HKnuiBEuEjH3')}",  content_type: 'application/json')
    #    headers:{Authorization: "Basic #{Base64.encode64('USERNAME:PASSWORD')}"})
  #  )

  #  print response
  #  print "Finished"
  # OLD STRIPE SHIT
  #   customer = Stripe::Customer.create(
  #       :email => current_user.email,
  #       :source => params[:stripe_token],
  # )
  #   Stripe::Charge.create(
  #       :customer => customer.id,
  #       :amount => order.amount_in_ore,
  #       :description => 'Köp på www.sof17.se',
  #       :currency => 'sek',
  #   )
  end
end
