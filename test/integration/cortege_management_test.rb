require 'test_helper'

class CortegeManagementTest < AuthenticatedIntegrationTest
  test 'normal users cannot list all corteges' do
    assert_raises (Exception) {
      get '/api/v1/cortege', headers: auth_headers
    }
  end

  test 'users with permissions can list all corteges' do
    current_user.permissions |= Permission::LIST_CORTEGE_APPLICATIONS
    current_user.save!

    get '/api/v1/cortege', headers: auth_headers
    assert_response :success
  end

  test 'users without permissions can not view another cortege' do
    assert_raises (Exception) {
      get '/api/v1/cortege/2', headers: auth_headers
    }
  end

  test 'users with permissions can view another cortege' do
    current_user.permissions |= Permission::LIST_CORTEGE_APPLICATIONS
    current_user.save!

    get '/api/v1/cortege/2', headers: auth_headers
    assert_response :success
  end

  test 'users with permissions can update the approval status' do
    current_user.permissions |= Permission::APPROVE_CORTEGE_APPLICATIONS
    current_user.save!

    put '/api/v1/cortege/1', headers: auth_headers, params: {item: {status: 'approved', approved: true}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    cortege = JSON.parse response.body

    assert_equal 'approved', cortege['status']
    assert cortege['approved']
  end

  test 'users with approval permissions can not update other columns' do
    current_user.permissions |= Permission::LIST_CORTEGE_APPLICATIONS | Permission::APPROVE_CORTEGE_APPLICATIONS
    current_user.save!

    # Make sure there is an existing user with id=2
    new_user = create_user 'user2@sof17.se'
    assert_equal 2, new_user.id

    put '/api/v1/cortege/2', headers: auth_headers, params: {item: {name: 'New name', approved: true}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    cortege = JSON.parse response.body

    assert_not_equal 'New name', cortege['name']
    assert cortege['approved']
  end

  test 'users with approval permissions can update other columns for their own cortege' do
    current_user.permissions |= Permission::LIST_CORTEGE_APPLICATIONS | Permission::APPROVE_CORTEGE_APPLICATIONS
    current_user.save!

    put '/api/v1/cortege/1', headers: auth_headers, params: {item: {name: 'New name', approved: true}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    cortege = JSON.parse response.body

    assert_equal 'New name', cortege['name']
    assert cortege['approved']
  end
end