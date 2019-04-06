class API::V1::PaymentController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def charge
          # Avoid sending the session_id to the front end,
      order = "hej"
      created_charge = create_credit_session(order)

      return_copy = created_charge
      return_copy.delete("session_id")
      render :status => '200', :json => return_copy
    #Add
    # end
  end

  def place_order
    res = create_order(params[:auth_token])
    p params[:auth_token]
    render :status => '200', :json => res
# unless current_user.shopping_cart_count == 0
    #   order = current_user.cart.create_order
    #   p "dead?"
    #   if !order.nil? && order.purchasable?
    #     if order.amount == 0
    #       order.complete_free_checkout!
    #     else
    #       created_charge = create_charge!(order)
    #       order.complete! created_charge
    #     end
    #     current_user.cart.empty!
    #
    #     # redirect_to api_v1_order_url(order)
    #   else
    #     p "There's nothing in your cart"
    #     head :not_acceptable
    #   end
    #   # rescue
    #     # raise e.message


  end

  private

  require 'uri'
  require 'net/http'
  require 'json'

  # Old stripe function
  # def create_charge!(order)
  #   customer = Stripe::Customer.create(
  #     :email => current_user.email,
  #     :source => params[:stripe_token],
  #   )
  #
  #   Stripe::Charge.create(
  #     :customer => customer.id,
  #     :amount => order.amount_in_ore,
  #     :description => 'Köp på www.sof17.se',
  #     :currency => 'sek',
  #   )
  # end

  def create_order(auth_token)

    url = URI(ENV['KLARNA_API_ENDPOINT']+"/payments/v1/authorizations/"\
          +auth_token+"/customer-token")
    http = Net::HTTP.new(url.host, url.port)
    # Required because KLARNA API only accepts https requests
    http.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/json'
    # Base64::encode64 magically creates a \n for some weird reason? Use Base64::strict_encode64
    request["Authorization"] = 'Basic '+ Base64.strict_encode64(ENV['KLARNA_API_USERNAME']+':'+ENV['KLARNA_API_PASSWORD'])
    request["cache-control"] = 'no-cache'
    request.body = "{
                      \"purchase_country\": \"SE\",
                      \"locale\": \"sv-SE\",
                      \"billing_address\" : {
                        \"given_name\": \"Doe\",
                        \"family_name\": \"John\",
                        \"email\": \"direct_debit@klarna.com\",
                        \"phone\": \"01895808221\",
                        \"street_address\": \"Stårgatan 1\",
                        \"postal_code\": \"12345\",
                        \"city\": \"Ankeborg\",
                        \"country\": \"SE\"
                      },
                      \"description\": \"MySaaS subscription\",
                      \"intended_use\": \"subscription\",
                      \"merchant_urls\": {
                        \"confirmation\": \"string\"
                      }"
    response = http.request(request)

    #  if response.code === 200
    #  Add error checks!
    result = JSON.parse(response.body)
    puts result

    return result
  end

  def create_credit_session(items)



      print items

      url = URI(ENV['KLARNA_API_ENDPOINT']+"/payments/v1/sessions")
      http = Net::HTTP.new(url.host, url.port)
      # Required because KLARNA API only accepts https requests
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = 'application/json'
      # Base64::encode64 magically creates a \n for some weird reason? Use Base64::strict_encode64
      request["Authorization"] = 'Basic '+ Base64.strict_encode64(ENV['KLARNA_API_USERNAME']+':'+ENV['KLARNA_API_PASSWORD'])
      request["cache-control"] = 'no-cache'
      request.body = "{
                        \"purchase_country\": \"SE\",
                        \"purchase_currency\" : \"sek\",
                        \"order_amount\": 10,
                        \"order_lines\":
                          [
                            {
                              \"type\" : \"digital\",
                              \"quantity\": 1,
                              \"total_amount\": 10,
                              \"unit_price\": 10,
                              \"name\" : \"Ticket\"
                            }
                          ],
                          \"merchant_urls\": {},
                          \"disable_client_side_updates\": true,
                          \"acquiring_channel\": \"IN_STORE\"
                      }"

      response = http.request(request)

      #  if response.code === 200
      #  Add error checks!
      result = JSON.parse(response.body)
      puts result

      return result

  end




end
