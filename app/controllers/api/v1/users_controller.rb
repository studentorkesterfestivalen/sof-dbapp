class API::V1::UsersController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  USER_SOURCES_PRIORITY = [
    :liu_id,
    :email,
    :name
  ]

  USER_COUNT_SEARCH_LIMIT = 10

  def index
    raise 'Listing all users not supported'
  end

  def show
    if params[:id].nil?
      render json: current_user,
             except: [
               :created_at,
               :updated_at,
               :permissions
             ],
             include: {
               case_cortege: {},
               cortege: {},
               orchestra: {},
               orchestra_signup: {
                 include: [
                   :orchestra
                 ]
               },
               funkis_application: {
                 include: [
                   funkis_shift_applications: {
                     include: [
                       funkis_shift: {
                         include: [
                           :funkis_category
                         ],
                         except: [
                           :maximum_workers
                         ]
                       }
                     ]
                   }
                 ],
                 methods: [
                   :steps_completed
                 ]
               }
             },
             methods: [
                 :is_lintek_member,
                 :shopping_cart_count
             ]
    else
      require_admin_permission AdminPermission::LIST_USERS

      user = User.find(params[:id])
      if user.present?
        render json: user, include: [:funkis_application]
      else
        render :status => '404', :json => {:message => 'Användare kunde inte hittas'}
      end
    end
  end

  def create
    raise 'User creation not supported'
  end

  def update
    user = User.find(params[:id])
    if current_user.has_admin_permission? AdminPermission::MODIFY_USERS
      # Only allows a admin to update a users display_name and permissions
      if user.update(user_admin_params)
        redirect_to api_v1_user_url(user)
      else
        raise 'Unable to save user'
      end
    else
      require_ownership user
      # Only allows user to update his display_name
      if user.update(user_params)
        redirect_to '/api/v1/user'
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

    require_admin_permission AdminPermission::DELETE_USERS
    user.destroy

    head :no_content
  end

  def find_ids
    require_admin_permission AdminPermission::LIST_USERS

    users = find_users_id_from_query
    if users.present?
      render :json => users, :only => ['id']
    else
      render :status => '404', :json => {:message => 'Användaren kunde inte hittas'}
    end
  end

  private

  def user_params
    params.require(:user).permit(
        :display_name
    )
  end

  def user_admin_params
    require_admin_permission AdminPermission::MODIFY_USERS

    params.require(:user).permit(
        :display_name,
        :admin_permissions,
        :usergroup
    )
  end

  # Ordered with least complexity first
  def find_users_id_from_query
    if query_is_mifare_number?
      find_users_from :card
    else
      found_user_ids = Set.new

      USER_SOURCES_PRIORITY.each do |source|
        if found_user_ids.size < USER_COUNT_SEARCH_LIMIT
          found_user_ids.merge(find_users_from source)
        end
      end

      found_user_ids.take(USER_COUNT_SEARCH_LIMIT)
    end
  end

  def find_users_from(source)
    res = nil
    case source
      when :card
        res = find_users_from_kobra(params[:query])
      when :liu_id
        res = User.where('nickname like ?', "%#{params[:query]}%").limit(USER_COUNT_SEARCH_LIMIT)
      when :email
        res = User.where('email like ?', "%#{params[:query]}%").limit(USER_COUNT_SEARCH_LIMIT)
      when :name
        res = User.where('display_name like ?', "%#{params[:query]}%").limit(USER_COUNT_SEARCH_LIMIT)
      else
        []
    end
    if res.present?
      res
    else
      []
    end
  end

  def find_users_from_kobra(card_id)
    begin
      kobra = Kobra::Client.new(api_key: Rails.configuration.kobra_api_key)
      response = kobra.get_student(id: card_id)
      liu_id = response[:liu_id]

      User.where('nickname like ?', "%#{liu_id}%").limit(1)
    rescue
      []
    end
  end

  def query_is_mifare_number?
    !!(params[:query] =~ /\A[0-9]+\z/)
  end
end
