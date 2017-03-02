class API::V1::ShoppingProductController < ApplicationController
  def index
    render :json => ShoppingProduct.where(enabled: true)
  end

  def create
    raise 'Not implemented'
  end

  def show
    render :json => ShoppingProduct.find_by_id(params[:id])
  end

  def update
    raise 'Not implemented'
  end

  def destroy
    raise 'Not implemented'
  end
end
