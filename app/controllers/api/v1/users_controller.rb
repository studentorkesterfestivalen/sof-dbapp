class API::V1::UsersController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    require_permission Permission::LIST_USERS

    render :json => User.all
  end

  def show
    if params[:id].nil?
      render json: current_user, except: [:created_at, :updated_at]
    else
      user = User.find(params[:id])
      if current_user.has_permission? Permission::LIST_USERS
        render json: user
      else
        require_ownership user
        render json: user, except: [:created_at, :updated_at]
      end
    end
  end

  def create
    raise 'User creation not supported'
  end

  def update
    user = User.find(params[:id])
    if current_user.has_permission? Permission::MODIFY_USERS
      if user.update(user_admin_params)
        redirect_to api_v1_user_url(user)
      else
        raise 'Unable to save user'
      end
    else
      require_ownership user

      if user.update(user_params)
        redirect_to api_v1_user_url(user)
      else
        raise 'Unable to save profile'
      end
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.has_owner? current_user
      raise 'Cannot delete current user, use auth endpoint instead'
    end

    require_permission Permission::DELETE_USERS
    user.destroy

    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(
        :name
    )
  end

  def user_admin_params
    require_permission Permission::MODIFY_USERS

    params.require(:user).permit(
        :name,
        :permissions
    )
  end
end
