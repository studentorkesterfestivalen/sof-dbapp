class UserController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user, except: [:created_at, :updated_at]
  end
end
