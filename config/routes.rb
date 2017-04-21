Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :menu
      resources :pages do
        collection do
          get 'find(/:category)(/:page)', action: 'find'
        end
      end
      resources :orchestra
      resources :orchestra_signup do
        collection do
          get 'verify', action: 'verify_code'
        end
      end
      resources :article
      resources :users
      resources :cortege
      resources :case_cortege
      resources :payments
      resources :shopping_product
      resources :user_groups

      scope '/cart' do
        get '/', to: 'shopping_cart#show'
        delete '/', to: 'shopping_cart#clear'
        put '/item', to: 'shopping_cart#add_item'
        delete '/item/:id', to: 'shopping_cart#delete_item'
      end

      get 'user', to: 'users#show'
    end
  end

  # Let’s encrypt
  get '/.well-known/acme-challenge/:id' => 'lets_encrypt#challenge', as: :letsencrypt_challenge

end
