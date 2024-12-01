# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :api do
    resources :checks, only: %i[create]
  end

  scope module: :web do
    root 'welcome#index'

    get 'auth/destroy', to: 'auth#destroy'
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    post 'auth/:provider', to: 'auth#request', as: :auth_request

    resources :repositories, only: %i[index show new create] do
      scope module: :repositories do
        resources :checks, only: %i[show create]
      end
    end
  end
end
