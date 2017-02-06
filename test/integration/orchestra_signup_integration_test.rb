require 'test_helper'

class OrchestraSignupIntegrationTest < AuthenticatedIntegrationTest
  test 'create orchestra' do
    Orchestra.delete_all

    post '/api/v1/orchestra', params: {item: {name: 'Testorkester'}}, headers: auth_headers, as: :json
    assert_response :redirect
  end

  test 'join orchestra' do
    OrchestraSignup.delete_all

    post '/api/v1/orchestra_signup', headers: auth_headers, params: {item: {code: 'cafebabe'}}
    assert_response :redirect
  end

  test 'join orchestra with case insensitive code' do
    OrchestraSignup.delete_all

    post '/api/v1/orchestra_signup', headers: auth_headers, params: {item: {code: 'CAFEbabe'}}
    assert_response :redirect
  end

  test 'joining orchestra with closed signup' do
    assert_raises (Exception) {
      post '/api/v1/orchestra_signup', headers: auth_headers, params: {item: {code: 'deadbeef'}}
    }
  end

  test 'extra orders in signup' do
    OrchestraSignup.delete_all

    post '/api/v1/orchestra_signup', headers: auth_headers, params: {
        item: {
            code: 'cafebabe',
            orchestra_ticket_attributes: {
                kind: 1
            },
            orchestra_food_ticket_attributes: {
                kind: 1,
                diet: 'Peanuts'
            },
            orchestra_articles_attributes: [
                {
                    kind: 1,
                    data: 'M'
                },
                {
                    kind: 1,
                    data: 'L'
                },
                {
                    kind: 2
                }
            ]
        }
    }
    assert_response :redirect

    get redirected_url, headers: auth_headers
    signup = JSON.parse response.body

    assert_equal signup['orchestra_articles'].count, 3
    assert_equal signup['orchestra_ticket']['kind'], 1
    assert_equal signup['orchestra_food_ticket']['diet'], 'Peanuts'
  end

  test 'modifying signup' do
    put '/api/v1/orchestra_signup/1', headers: auth_headers, params: {item: {dormitory: true}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    signup = JSON.parse response.body

    assert_equal signup['dormitory'], true
  end

  test 'inherit dormitory' do
    get '/api/v1/orchestra_signup/2', headers: auth_headers
    assert_response :success

    signup = JSON.parse response.body

    assert_equal signup['dormitory'], true
  end

  test 'orchestra owner can view member signups' do
    get '/api/v1/orchestra_signup/3', headers: auth_headers
    assert_response :success
  end

  test 'orchestra owner can generate a new access code' do
    get "/api/v1/orchestra/#{orchestras(:default).id}", headers: auth_headers
    assert_response :success

    orchestra = JSON.parse response.body
    access_code = orchestra['code']

    put "/api/v1/orchestra/#{orchestras(:default).id}", headers: auth_headers, params: {item: {code: 'reset'}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    orchestra = JSON.parse response.body

    assert_not_equal access_code, orchestra['code']
  end
end