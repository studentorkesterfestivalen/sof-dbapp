require 'test_helper'

class PageAdministrationTest < ActionDispatch::IntegrationTest
  test 'add page' do
    old_count = fetch_pages.size

    # Add new page
    post '/api/v1/pages', params: {item: {
        category: 'cat1',
        page: 'page1',
        header: 'Header',
        content: 'Hello world!',
        show_in_menu: true
    }}, as: :json

    new_count = fetch_pages.size

    assert_equal old_count + 1, new_count, 'Page was not created'
  end

  test 'update page' do
    items = fetch_pages
    item_to_update = items.first

    # Update header for page
    put "/api/v1/pages/#{item_to_update['id']}", params: {item: {header: 'New header'}}, as: :json

    get '/api/v1/pages'
    assert_match /New header/, @response.body, 'Page was not updated'
  end

  test 'delete page' do
    items = fetch_pages
    item_to_delete = items.first
    old_count = items.size

    delete "/api/v1/pages/#{item_to_delete['id']}"

    new_count = fetch_pages.size

    assert_equal old_count - 1, new_count, 'Page was not deleted'
  end

  private

  def fetch_pages
    get '/api/v1/pages'
    JSON.parse @response.body
  end
end