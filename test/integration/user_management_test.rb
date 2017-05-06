require 'test_helper'

class UserManagementTest < AuthenticatedIntegrationTest
  test 'showing current user requires no permissions' do
    get '/api/v1/user', headers: auth_headers
    assert_response :success
  end

  test 'showing current user via management url requires permissions' do
    assert_raises (Exception) {
      get '/api/v1/users/1', headers: auth_headers
    }

    current_user.admin_permissions |= AdminPermission::LIST_USERS
    current_user.save!

    get '/api/v1/users/1', headers: auth_headers
    assert_response :success
  end

  test 'showing another user requires permission' do
    new_user = create_user 'foo@sof17.se'

    assert_raises (Exception) {
      get "/api/v1/users/#{new_user.id}", headers: auth_headers
    }

    current_user.admin_permissions |= AdminPermission::LIST_USERS
    current_user.save!

    get "/api/v1/users/#{new_user.id}", headers: auth_headers
    assert_response :success
  end

  test 'searching users requires permissions' do
    assert_raises (Exception) {
      get '/api/v1/users/search', headers: auth_headers
    }

    current_user.admin_permissions |= AdminPermission::LIST_USERS
    current_user.save!

    get "/api/v1/users/search/?query=foo", headers: auth_headers
    assert_response 404
  end

  test 'normal users can update their display name' do
    put '/api/v1/users/1', headers: auth_headers, params: {user:{display_name: 'SOF-Putten'}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    user = JSON.parse response.body

    assert_equal 'SOF-Putten', user['display_name']
  end

  test 'normal users can not grant themselves permissions' do
    put '/api/v1/users/1', headers: auth_headers, params: {user:{permissions: AdminPermission::ALL}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    user = JSON.parse response.body

    assert_not_equal AdminPermission::ALL, user['permissions']
  end

  test 'users with permission can grant themselves and other users permissions' do
    current_user.admin_permissions |= AdminPermission::LIST_USERS | AdminPermission::MODIFY_USERS
    current_user.save!

    new_user = create_user 'foo@sof17.se'
    put "/api/v1/users/#{new_user.id}", headers: auth_headers, params: {user:{admin_permissions: AdminPermission::DELETE_USERS}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    user = JSON.parse response.body

    assert_equal AdminPermission::DELETE_USERS, user['admin_permissions']

    put '/api/v1/users/1', headers: auth_headers, params: {user:{admin_permissions: AdminPermission::ALL}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    user = JSON.parse response.body

    assert_equal AdminPermission::ALL, user['admin_permissions']
  end

  test 'normal users cannot delete their own accounts' do
    # Deletion of the logged in user can only be made from the devise token auth endpoint

    assert_raises (Exception) {
      delete '/api/v1/users/1', headers: auth_headers
    }

    assert_not_nil User.find_by_id(1)
  end

  test 'normal users can not delete other accounts' do
    new_user = create_user 'foo@sof17.se'
    assert_raises (Exception) {
      delete "/api/v1/users/#{new_user.id}", headers: auth_headers
    }

    assert_not_nil User.find_by_id(new_user.id)
  end

  test 'users with admin_permissions can delete other accounts' do
    current_user.admin_permissions |= AdminPermission::DELETE_USERS
    current_user.save!

    new_user = create_user 'foo@sof17.se'
    delete "/api/v1/users/#{new_user.id}", headers: auth_headers
    assert_response :success

    assert_nil User.find_by_id(new_user.id)
  end
end