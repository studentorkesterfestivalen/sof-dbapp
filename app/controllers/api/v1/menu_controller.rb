class API::V1::MenuController < ApplicationController

  def index
    items = MenuItem.where(menu_item_id: nil)
    items.each { |x| x.setup_for current_user }
    items = items.select { |x| x.should_show? }

    render :json => items, :include => [:menu_items]
  end

  def create
    restrict_access

    menu_item = MenuItem.new(item_params)
    menu_item.save

    redirect_to api_v1_menu_url(menu_item)
  end

  def show
    render :json => MenuItem.find(params[:id])
  end

  def update
    restrict_access

    menu_item = MenuItem.find(params[:id])

    if menu_item.update(item_params)
      redirect_to api_v1_menu_url(menu_item)
    else
      raise 'Unable to save menu item'
    end
  end

  def destroy
    restrict_access

    menu_item = MenuItem.find(params[:id])
    menu_item.destroy

    head :no_content
  end

  private

  def item_params
    # TODO: Support creating and modifying nested menu items
    params.require(:item).permit(:title, :active)
  end

  def restrict_access
    unless Rails.env.development? or Rails.env.test?
      # TODO: Restrict access using a proper system before enabling in production
      raise 'Permission denied'
    end
  end

end
