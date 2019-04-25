class API::V1::PaymentController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!
  require 'json'

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
      if items.empty?
        render :status => '400', :json => {'message': "Cart is empty"}
      else
        response = create_credit_session(items)
        if response.code == "200"
          parsed_body = JSON.parse(response.body)
          #print "This is the session_id: " + parsed_body['session_id']
          render :status => '200', :json => response.body
        else
          print JSON.parse(response.body)
          render :status => '400', :json => {'message': "Could not create/fetch session"}
        end
      end
  end



  def place_order
    items = generate_order_lines
    if items.empty?
        render :status => '400', :json => {'message': "Cart is empty"}
    else
      res = create_order(params[:auth_token], items)
      if res.code == '200'
        res = JSON.parse(res.body)
        order = current_user.cart.create_order(res['order_id'])
        render :status => '200', :json => res['redirect_url']
      elsif res.code == '400'
        render :status => '400', :json => {'message' : "We were unable to create an order with the provided data. Some field constraint was violated. "}
      elsif res.code == '403'
        render :status => '403', :json => {'message': "You were not authorized to execute this operation."}
      elsif res.code == '404'
        render :status => '404', :json => {'message': "The authorization does not exist."}
      elsif res.code == '409'
        render :status => '409', :json => {'message': "The data in the request does not match the session for the authorization."}
      end
    end
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

    lang = nil
    if I18n.locale.to_s == 'sv'
      lang = "sv-SE"
    else
      lang = "en-GB"
    end

    url = URI(ENV['KLARNA_API_ENDPOINT'] + "/payments/v1/authorizations/"+auth_token+"/order")
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
                      \"locale\": \"" + lang + "\",
                      \"order_amount\": "+total_amount.to_s() + ",
                        \"order_lines\":
                        "+items.to_json+
                          ",
                      \"merchant_urls\": {
                        \"confirmation\": \"" + ENV['KLARNA_PAYMENT_REDIRECT'] + "\"
                      }
                    }"

    http.request(request)
    #  if response.code === 200
    #  Add error checks!
    # result = JSON.parse(response.body)
    # puts result

    # return result
  end

  def generate_order_lines
    #json_data = @current_user.cart.cart_items
    json_data = []
    unless current_user.cart.cart_items.empty?
      # current_user.cart.cart_itemsprint "\nNot nil\n\n"
      result = current_user.cart.cart_items.map{|cart_item|
        item = {}
        prod = Product.find_by(id: cart_item.product_id)
        base_prod = BaseProduct.find_by(id: prod.base_product_id)
        # Some products have no name, add base_product name just in case
        unless prod.kind.nil?
          item[:name] = base_prod.name + " " + prod.kind
        else
          item[:name] = base_prod.name
        end
        item[:type] = 'digital'
        item[:unit_price] = prod.actual_cost * 100
        item[:quantity] = cart_item.amount
        item[:total_amount] = item[:quantity] * item [:unit_price]
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
      # result.each do |order_line|
      #   temp_data = {}
      #   temp_data[:name] = order_line[:name]
      #   temp_data[:unit_price] = order_line[:unit_price]#order_line['cost']
      #   temp_data[:type] = "digital"
      #   temp_data[:quantity] = order_line[:amount]
      #   temp_data[:total_amount] = temp_data[:quantity] * temp_data[:unit_price]
      #   json_data.append(temp_data)
      # end
      # print result.to_json
      json_data = result
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
      items.each do |order_line|
        total_amount += order_line[:total_amount]
      end
      # total_amount = total_amount.to_s

      url = URI(ENV['KLARNA_API_ENDPOINT'] + "/payments/v1/sessions")
      http = Net::HTTP.new(url.host, url.port)
      # Required because KLARNA API only accepts https requests
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)

      print "\n\n\nYour current language is: " + I18n.locale.to_s + "\n\n\n"
      lang = nil
      if I18n.locale.to_s == 'sv'
        lang = "sv-SE"
      else
        lang = "en-GB"
      end
      print "\n\nThis is the language: " + lang + "\n\n"

      request["Content-Type"] = 'application/json'
      # Base64::encode64 magically creates a \n for some weird reason? Use Base64::strict_encode64
      request["Authorization"] = 'Basic '+ Base64.strict_encode64(ENV['KLARNA_API_USERNAME']+':'+ENV['KLARNA_API_PASSWORD'])
      request["cache-control"] = 'no-cache'
      request.body =" {
                        \"purchase_country\": \"SE\",
                        \"purchase_currency\": \"SEK\",
                        \"locale\": \""+lang+"\",
                        \"order_amount\":" + total_amount.to_s() + ",
                        \"order_lines\":
                          "+items.to_json+
                          ",
                          \"merchant_urls\": {},
                          \"disable_client_side_updates\": true,
                          \"acquiring_channel\": \"IN_STORE\"

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
