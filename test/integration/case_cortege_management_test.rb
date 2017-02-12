require 'test_helper'

class CaseCortegeManagementTest < AuthenticatedIntegrationTest
  test 'normal users cannot list all case corteges' do
    assert_raises (Exception) {
      get '/api/v1/case_cortege', headers: auth_headers
    }
  end

  test 'users with permissions can list all case corteges' do
    current_user.permissions |= Permission::LIST_CORTEGE_APPLICATIONS
    current_user.save!

    get '/api/v1/case_cortege', headers: auth_headers
    assert_response :success
  end

  test 'users without permissions can not view another case cortege' do
    assert_raises (Exception) {
      get '/api/v1/case_cortege/2', headers: auth_headers
    }
  end

  test 'users with permissions can view another case cortege' do
    current_user.permissions |= Permission::LIST_CORTEGE_APPLICATIONS
    current_user.save!

    get '/api/v1/case_cortege/2', headers: auth_headers
    assert_response :success
  end

  test 'users with permissions can update the approval status' do
    current_user.permissions |= Permission::APPROVE_CORTEGE_APPLICATIONS
    current_user.save!

    put '/api/v1/case_cortege/1', headers: auth_headers, params: {item: {status: 'approved', approved: true}}
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

    put '/api/v1/case_cortege/2', headers: auth_headers, params: {item: {group_name: 'New group name', approved: true}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    cortege = JSON.parse response.body

    assert_not_equal 'New group name', cortege['group_name']
    assert cortege['approved']
  end

  test 'users with approval permissions can update other columns for their own cortege' do
    current_user.permissions |= Permission::LIST_CORTEGE_APPLICATIONS | Permission::APPROVE_CORTEGE_APPLICATIONS
    current_user.save!

    put '/api/v1/case_cortege/1', headers: auth_headers, params: {item: {group_name: 'New group name', approved: true}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    cortege = JSON.parse response.body

    assert_equal 'New group name', cortege['group_name']
    assert cortege['approved']
  end
end