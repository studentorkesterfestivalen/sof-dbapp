require 'test_helper'

class ArticleManagementTest < AuthenticatedIntegrationTest
  test 'articles can not be listed without a logged in user' do
    get '/api/v1/article'
    assert_response 401
  end

  test 'enabled articles can be listed by logged in users' do
    get '/api/v1/article', headers: auth_headers
    assert_response :success

    articles = JSON.parse response.body
    articles.each { |article| assert article['enabled'] }
  end

  test 'enabled and disabled articles can be listed by users with permissions' do
    current_user.permissions |= AdminPermission::MODIFY_ARTICLES
    current_user.save!

    get '/api/v1/article', headers: auth_headers
    assert_response :success

    articles = JSON.parse response.body
    assert articles.any? { |article| !article['enabled'] }
  end

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
    current_user.permissions |= AdminPermission::MODIFY_ARTICLES
    current_user.save!

    post '/api/v1/article', headers: auth_headers, params: {item: dummy_article}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    assert_response :success
  end

  test 'articles can be modified by users with permissions' do
    current_user.permissions |= AdminPermission::MODIFY_ARTICLES
    current_user.save!

    put '/api/v1/article/1', headers: auth_headers, params: {item: {name: 'Shirt'}}
    assert_response :redirect

    get redirected_url, headers: auth_headers
    assert_response :success

    article = JSON.parse response.body
    assert_equal 'Shirt', article['name']
  end

  test 'articles can be deleted by users with permissions' do
    current_user.permissions |= AdminPermission::MODIFY_ARTICLES
    current_user.save!

    delete '/api/v1/article/1', headers: auth_headers
    assert_response :success

    assert_nil AvailableArticle.find_by_id(1)
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