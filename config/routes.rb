Rails.application.routes.draw do
  root "welcome#index"

  resources :repositories

  post 'auth/:provider', to: 'auth#request', as: :auth_request
  get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
  get 'auth/destroy', to: 'auth#destroy'
end
