require 'test_helper'

class ArticleManagementTest < AuthenticatedIntegrationTest
  test 'users without permissions cannot create, modify or delete articles' do
    assert_raises (Exception) {
      post '/api/v1/article', headers: auth_headers, params: {item: dummy_article}
    }

    assert_raises (Exception) {
      put '/api/v1/article/1', headers: auth_headers, params: {item: {name: 'Other name'}}
    }

    assert_raises (Exception) {
      delete '/api/v1/article/1', headers: auth_headers
    }
  end

  test 'articles can be created by users with permissions' do
    current_user.permissions |= Permission::MODIFY_ARTICLES
    current_user.save!

    post '/api/v1/article', headers: auth_headers, params: {item: dummy_article}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    assert_response :success
  end

  def dummy_article
    {
        name: 'T-shirt',
        description: 'Bekväm T-shirt med SOF-tryck',
        price: 9000,
        data_name: 'Storlek',
        data_description: 'Vilken storlek vill du ha?',
        orchestra_only: true
    }
  end
end