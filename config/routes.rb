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
      resources :orchestra_signup
      resources :article
    end
  end

  get '/api/v1/user', to: 'user#index'

  # Let’s encrypt
  get '/.well-known/acme-challenge/:id' => 'lets_encrypt#challenge', as: :letsencrypt_challenge

end
