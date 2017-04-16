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
        end
      end
      resources :orchestra_signup do
        get 'verify', action: 'verify_code', on: :collection
      end
      resources :article
      resources :users
      resources :cortege
      resources :case_cortege
      resources :funkis
      resources :funkis_shift do
        get 'export_applications', on: :collection
      end
      resources :funkis_application

      get 'user', to: 'users#show'
    end
  end

  # Let’s encrypt
  get '/.well-known/acme-challenge/:id' => 'lets_encrypt#challenge', as: :letsencrypt_challenge

end
