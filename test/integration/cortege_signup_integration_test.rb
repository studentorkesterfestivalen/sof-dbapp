require 'test_helper'

class CortegeSignupIntegrationTest < AuthenticatedIntegrationTest
  test 'create cortege signup' do
    prepare_cortege_creation!

    post '/api/v1/cortege', headers: auth_headers, params: {
        item: {
          name: 'Test cortege',
          student_association: 'LiTHe Kårtege',
          participant_count: 37,
          cortege_type: 2,
          contact_phone: '0701234567',
          idea: 'Great idea',
          comments: 'Great comments'
        }
    }

    assert_response :redirect

    get redirected_url, headers: auth_headers
    cortege = JSON.parse response.body

    assert_equal 'Test cortege',    cortege['name']
    assert_equal 'LiTHe Kårtege',   cortege['student_association']
    assert_equal  37,               cortege['participant_count']
    assert_equal  2,                cortege['cortege_type']
    assert_equal '0701234567',      cortege['contact_phone']
    assert_equal 'Great idea',      cortege['idea']
    assert_equal 'Great comments',  cortege['comments']
  end

  test 'update cortege signup' do
    put '/api/v1/cortege/1', headers: auth_headers, params: {item: {idea: 'Updated idea'}}

    assert_response :redirect

    get redirected_url, headers: auth_headers
    cortege = JSON.parse response.body

    assert_equal 'Updated idea', cortege['idea']
  end

  test 'delete cortege signup' do
    delete '/api/v1/cortege/1', headers: auth_headers
    assert_response :success
  end

  def prepare_cortege_creation!
    # A user can at most have one cortege created. Since the fixtures are preconfigured with already existing
    # corteges they must be removed before running any tests involving creating corteges. Note that the fixtures
    # may contain a configuration with multiple corteges belonging to a single user, necessitating delete_all.
    Cortege.where(user: current_user).delete_all
  end
end