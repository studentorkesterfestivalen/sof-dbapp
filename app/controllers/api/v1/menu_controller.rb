class API::V1::MenuController < ApplicationController

  def index
    # TODO: Unwrap child menu items into resulting json data
    render :json => MenuItem.where(parent_id: nil), :include => [:menu_items]

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

    # What is preferably returned here?
    render :json => []
  end

  private

  def item_params
    params.require(:item).permit(:title, :active)
  end

  def restrict_access
    unless Rails.env.development? or Rails.env.test?
      # TODO: Restrict access using a proper system before enabling in production
      raise 'Permission denied'
    end
  end

end
