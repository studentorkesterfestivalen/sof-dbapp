require 'test_helper'

class MenuAdministrationTest < ActionDispatch::IntegrationTest
  # General thoughts
  # Is it preferred to check the modifications directly in the database instead
  # of querying the API for this information?

  test 'add menu item' do
    old_count = fetch_menu_items!.size

    # Add new menu item
    post '/api/v1/menu', params: {item: {title: 'Test item'}}, as: :json

    new_count = fetch_menu_items!.size

    assert_equal old_count + 1, new_count, 'Menu item was not created'
  end

  test 'update menu item' do
    items = fetch_menu_items!
    item_to_update = items.first

    # Update title for menu item
    put api_v1_menu_url(item_to_update['id']), params: {item: {title: 'New title'}}, as: :json

    get '/api/v1/menu'
    assert_match /New title/, @response.body, 'Menu item was not updated'
  end

  test 'delete menu item' do
    items = fetch_menu_items!
    item_to_delete = items.first
    old_count = items.size

    delete api_v1_menu_url(item_to_delete['id'])

    new_count = fetch_menu_items!.size

    assert_equal old_count - 1, new_count, 'Menu item was not deleted'
  end

  private

  def fetch_menu_items!
    get '/api/v1/menu'
    JSON.parse @response.body
  end
end