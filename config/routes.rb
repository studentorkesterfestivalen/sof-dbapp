Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :menu
      resources :pages do
        get 'find(/:category)(/:page)', action: 'find', on: :collection
      end
      resources :orchestra do
        get 'all_signups', action: 'all_signups', on: :member
        collection do
          get 'item_summary', action: 'item_summary'
          get 'extra_performances', action: 'extra_performances'
          get 'anniversary', action: 'anniversary'
          get 'allergies', action: 'allergies'
          get 'lintek_rebate', action: 'lintek_rebate'
          get 'list_all', action: 'list_all'
          get 'overlaps', action: 'overlapping_orchestras'
        end
      end
      resources :orchestra_signup do
        get 'verify', action: 'verify_code', on: :collection
        put 'update_shirt_size/:id', action: 'update_shirt_size', on: :collection
      end
      resources :article

      resources :users do
        get 'search', action: 'find_ids', on: :collection
        get 'get_user', action: 'get_user', on: :collection
        get 'get_user_uuid', action: 'get_user_uuid', on: :collection
        post 'set_liu_card_number', action: 'set_liu_card_number', on: :collection
      end

      resources :cortege
      resources :case_cortege
      resources :payments
      resources :shopping_product do
        put 'sold_separately', action: 'increase_count', on: :collection
        put 'decrease_separately', action: 'decrease_count', on: :collection
      end
      resources :user_groups do
        post 'modify_membership', action: 'modify_membership', on: :member
      end

      resources :funkis
      resources :funkis_shift do
        get 'export_applications', on: :collection
      end
      resources :funkis_application

      resources :lineups do
        get 'artists_from_lineups', action: 'get_artists', on: :collection
        get 'corteges_from_lineups', action: 'get_corteges', on: :collection
      end

      resources :cortege_membership do
        get 'cortege/:id', action: 'show_cortege_members', on: :collection
        get 'case_cortege/:id', action: 'show_case_cortege_members', on: :collection
      end
      resources :order
      resources :order_item
      resources :base_product do
        get 'statistics', action: 'statistics', on: :collection
      end
      resources :faq
      resources :faq_group

      scope '/cart' do
        get '/', to: 'shopping_cart#show'
        put '/', to: 'shopping_cart#set_cart'
        delete '/', to: 'shopping_cart#clear'
        put '/item', to: 'shopping_cart#add_item'
        delete '/item/', to: 'shopping_cart#delete_item'
        put '/discount', to: 'shopping_cart#apply_discount_code'
      end

      scope '/store' do
        post '/charge', to: 'payment#charge'
      end

      scope '/collect' do
        get '/:uuid', to: 'item_collect#show'
        get '/liu_card/:liu_card_number', to: 'item_collect#liu_card'
        post '/', to: 'item_collect#collect'
      end

      scope '/order_stats' do
        get '/', to: 'order_statistics#summary'
        get '/measures', to: 'order_statistics#key_measures'
      end

      get 'user', to: 'users#show'
    end
  end

  # Let’s encrypt
  get '/.well-known/acme-challenge/:id' => 'lets_encrypt#challenge', as: :letsencrypt_challenge



end
