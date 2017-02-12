require 'test_helper'

class CaseCortegeSignupIntegrationTest < AuthenticatedIntegrationTest
  test 'create case cortege signup' do
    prepare_case_cortege_creation!

    post '/api/v1/case_cortege', headers: auth_headers, params: {
        item: {
            education: 'Education',
            contact_phone: '0701234567',
            case_cortege_type: 1,
            group_name: 'Group',
            motivation: 'Movivation'
        }
    }

    assert_response :redirect

    get redirected_url, headers: auth_headers
    cortege = JSON.parse response.body

    assert_equal 'Education',   cortege['education']
    assert_equal '0701234567',  cortege['contact_phone']
    assert_equal  1,            cortege['case_cortege_type']
    assert_equal 'Group',       cortege['group_name']
    assert_equal 'Movivation',  cortege['motivation']
  end

  test 'update case cortege signup' do
    put '/api/v1/case_cortege/1', headers: auth_headers, params: {item: {motivation: 'Updated motivation'}}

    assert_response :redirect

    get redirected_url, headers: auth_headers
    cortege = JSON.parse response.body

    assert_equal 'Updated motivation', cortege['motivation']
  end

  test 'delete case cortege signup' do
    delete '/api/v1/case_cortege/1', headers: auth_headers
    assert_response :success
  end

  def prepare_case_cortege_creation!
    # A user can at most have one case cortege created. Since the fixtures are preconfigured with already existing
    # case corteges they must be removed before running any tests involving creating case corteges. Note that the
    # fixtures may contain a configuration with multiple case corteges belonging to a single user, necessitating
    # delete_all.
    CaseCortege.where(user: current_user).delete_all
  end
end