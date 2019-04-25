class API::V1::PaymentController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def update_cart(order)

      cart = current_user.cart
      if !cart.session_id.nil? and (Time.now.utc - cart.session_updated_at.utc < 23.55.hours)
        response = update_session(order, cart.session_id)
        if response.code == "204"
          render :status => '200', :json => {'message': "Successfully updated cart at Klarna"}
        else
          render :status => '500', :json => {'message': "Could not update cart against Klarna API"}
        end
      else
        render :status => '400', :json => {'message': "Faulty request, no valid transaction session exist"}
      end
  end

  def charge
          # Avoid sending the session_id to the front end,
          # order = "hej"
      items = generate_order_lines
  #    if current_user.shopping_cart_count == 0
  #      render :status => '200'
  #    else
      # created_charge = create_credit_session(order)
      # return_copy = created_charge
      # return_copy.delete("session_id")
      # render :status => '200', :json => return_copy
    #Add
  #   end
  #  if order.nil?

  #    render :status => '400', :json => {'message': "Cart is empty"}
    #else
      response = create_credit_session(items)
      if response.code == "200"
        parsed_body = JSON.parse(response.body)
        #print "This is the session_id: " + parsed_body['session_id']
        render :status => '200', :json => response.body
      else
        print JSON.parse(response.body)
        render :status => '400', :json => {'message': "Could not create/fetch session"}
      end
  #  end
  end



  def place_order
    items = generate_order_lines
    res = create_order(params[:auth_token], items)
    render :status => '200', :json => res['redirect_url']
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

  def create_order(auth_token, items)
    total_amount = 0
    items.each do|order_line|
      total_amount += order_line[:total_amount]
    end

    url = URI(ENV['KLARNA_API_ENDPOINT'] + "/payments/v1/authorizations/"+auth_token+"/order")
    p url
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
                      \"purchase_currency\": \"SEK\",
                      \"locale\": \"sv-SE\",

                      \"order_amount\": "+total_amount.to_s() + ",
                        \"order_lines\":
                        "+items.to_json+
                          ",
                      \"merchant_urls\": {
                        \"confirmation\": \"http://localhost:3000/shop/payment_confirmation\"
                      }
                    }"
    response = http.request(request)

    #  if response.code === 200
    #  Add error checks!
    result = JSON.parse(response.body)
    puts result

    return result
  end

  def generate_order_lines
    #json_data = @current_user.cart.cart_items
    json_data = []
    unless current_user.cart.cart_items.empty?
      # current_user.cart.cart_itemsprint "\nNot nil\n\n"
      result = current_user.cart.cart_items.map{|cart_item|
        prod = Product.find_by(id: cart_item.product_id)
        item = prod.attributes.slice('kind')
        item['kind'] = prod.attributes.slice('name') + item['kind']
        item[:unit_price] = prod.actual_cost
        item[:amount] = cart_item.amount
        item
      }


      # {
      #   \"type\" : \"digital\",
      #   \"quantity\": 1,
      #   \"total_amount\": 1000,
      #   \"unit_price\": 1000,
      #   \"name\" : \"Ticket\"
      # },
      # {
      #   \"type\" : \"discount\",
      #   \"quantity\": 1,
      #   \"total_amount\": -990,
      #   \"unit_price\": -990,
      #   \"name\" : \"Rebate\"
      # }
    #  result = JSON.parse(result)
      result.each do |order_line|
        temp_data = {}
        temp_data[:name] = order_line['kind']
        temp_data[:unit_price] = order_line[:unit_price] * 100 #order_line['cost']
        temp_data[:type] = "digital"
        temp_data[:quantity] = order_line[:amount]
        temp_data[:total_amount] = temp_data[:quantity] * temp_data[:unit_price]
        json_data.append(temp_data)
      end
      print json_data.to_json
      # json_data = result

  #    json_data = current_user.cart.cart_items do |cart_item|
  #      print cart_item.as_json(include: :cart_item)
  #    end
    end
  #  print json_data
    json_data
  end

  def create_credit_session(items)



      #print items
      total_amount = 0
      items.each do|order_line|
        total_amount += order_line[:total_amount]
      end
      # total_amount = total_amount.to_s

      url = URI(ENV['KLARNA_API_ENDPOINT'] + "/payments/v1/sessions")
      http = Net::HTTP.new(url.host, url.port)
      # Required because KLARNA API only accepts https requests
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = 'application/json'
      # Base64::encode64 magically creates a \n for some weird reason? Use Base64::strict_encode64
      request["Authorization"] = 'Basic '+ Base64.strict_encode64(ENV['KLARNA_API_USERNAME']+':'+ENV['KLARNA_API_PASSWORD'])
      request["cache-control"] = 'no-cache'
      request.body =" {
                        \"purchase_country\": \"SE\",
                        \"purchase_currency\": \"SEK\",
                        \"locale\": \"se-SE\",
                        \"order_amount\":" + total_amount.to_s() + ",
                        \"order_lines\":
                          "+items.to_json+
                          ",
                          \"merchant_urls\": {},
                          \"disable_client_side_updates\": true,
                          \"acquiring_channel\": \"IN_STORE\",
                          \"options\": {
                            \"color_border\": \"#FF0000\",
                            \"color_border_selected\": \"#FF0000\",
                            \"color_button\": \"#FF0000\",
                            \"color_button_text\": \"#FF0000\",

                            \"color_checkbox_checkmark\": \"#FF0000\",
                            \"color_details\": \"#FF0000\",
                            \"color_header\": \"#FF0000\",
                            \"color_link\": \"#FF0000\",
                            \"color_text\": \"#FF0000\",
                            \"color_text_secondary\": \"#FF0000\",
                            \"radius_border\": \"5px\"
                          }
                      }"

      http.request(request)
      #
      # #  if response.code === 200
      # #  Add error checks!
      # result = JSON.parse(response.body)
      # puts result

      # return result

  end




end
