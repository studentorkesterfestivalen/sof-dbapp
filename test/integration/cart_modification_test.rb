require 'test_helper'

class CaseCortegeManagementTest < AuthenticatedIntegrationTest
  DUMMY_ITEM = {
      product_id: 1
  }

  test 'users can view their shopping cart' do
    get '/api/v1/cart', headers: auth_headers
    assert_response :success
  end

  test 'users can add items to their shopping cart' do
    put '/api/v1/cart/item', headers: auth_headers, params: {item: DUMMY_ITEM}
    assert_response :success

    get '/api/v1/cart', headers: auth_headers
    assert_response :success

    cart = JSON.parse response.body

    assert cart['cart_items'].any? { |x| x['product_id'] == DUMMY_ITEM[:product_id] }
  end

  test 'users can remove items from their shopping cart' do
    put '/api/v1/cart/item', headers: auth_headers, params: {item: DUMMY_ITEM}
    assert_response :success

    get '/api/v1/cart', headers: auth_headers
    assert_response :success

    cart = JSON.parse response.body
    assert cart['cart_items'].count == 1

    item_id = cart['cart_items'][0]['id']

    delete "/api/v1/cart/item/#{item_id}", headers: auth_headers
    assert_response :success

    get '/api/v1/cart', headers: auth_headers
    assert_response :success

    cart = JSON.parse response.body
    assert cart['cart_items'].count == 0
  end

  test 'users can clear their shopping carts' do
    10.times do
      put '/api/v1/cart/item', headers: auth_headers, params: {item: DUMMY_ITEM}
      assert_response :success
    end

    get '/api/v1/cart', headers: auth_headers
    assert_response :success

    cart = JSON.parse response.body
    assert cart['cart_items'].count == 10

    delete '/api/v1/cart', headers: auth_headers
    assert_response :success

    get '/api/v1/cart', headers: auth_headers
    assert_response :success

    cart = JSON.parse response.body
    assert cart['cart_items'].count == 0
  end

end