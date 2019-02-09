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
        end
      end
      resources :orchestra_signup do
        get 'verify', action: 'verify_code', on: :collection
      end
      resources :article

      resources :users do
        get 'search', action: 'find_ids', on: :collection
      end

      resources :cortege
      resources :case_cortege
      resources :payments
      resources :shopping_product
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
        delete '/', to: 'shopping_cart#clear'
        put '/item', to: 'shopping_cart#add_item'
        delete '/item/:id', to: 'shopping_cart#delete_item'
      end

      scope '/store' do
        post '/charge', to: 'payment#charge'
      end

      scope '/collect' do
        get '/:id', to: 'item_collect#show'
        post '/:id', to: 'item_collect#collect'
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
