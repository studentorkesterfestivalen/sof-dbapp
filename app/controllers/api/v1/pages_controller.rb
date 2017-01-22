class API::V1::PagesController < ApplicationController
  def index
    restrict_access

    render :json => Page.all
  end

  def create
    restrict_access

    page = Page.new(item_params)
    page.save

    redirect_to api_v1_page_url(page)
  end

  def show
    render :json => Page.find(params[:id])
  end

  def find
    category = params[:category] || 'index'
    page = params[:page] || ''

    render :json => Page.find_by!(category: category, page: page)
  end

  def update
    restrict_access

    page = Page.find(params[:id])

    if page.update(item_params)
      redirect_to api_v1_page_url(page)
    else
      raise 'Unable to save page'
    end
  end

  def destroy
    restrict_access

    page = Page.find(params[:id])
    page.destroy

    head :no_content
  end

  private

  def item_params
    params.require(:item).permit(:category, :page, :header, :content, :show_in_menu, :image)
  end

  def restrict_access
    unless Rails.env.development? or Rails.env.test?
      # TODO: Restrict access using a proper system before enabling in production
      raise 'Permission denied'
    end
  end
end
