require 'test_helper'

class OrchestraManagementTest < AuthenticatedIntegrationTest
  test 'normal users cannot list all orchestras' do
    assert_raises (Exception) {
      get '/api/v1/orchestra', headers: auth_headers
    }
  end

  test 'users with permissions can list all orchestras' do
    current_user.permissions |= AdminPermission::LIST_ORCHESTRA_SIGNUPS
    current_user.save!

    get '/api/v1/orchestra', headers: auth_headers
    assert_response :success
  end

  test 'normal users cannot list all orchestra signups' do
    assert_raises (Exception) {
      get '/api/v1/orchestra_signup', headers: auth_headers
    }
  end

  test 'users with permissions can list all orchestra signups' do
    current_user.permissions |= AdminPermission::LIST_ORCHESTRA_SIGNUPS
    current_user.save!

    get '/api/v1/orchestra_signup', headers: auth_headers
    assert_response :success
  end
end