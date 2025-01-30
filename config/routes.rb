Rails.application.routes.draw do
  devise_for :users

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'dashboard#index'
  
  get 'pending_approval', to: 'static_pages#pending_approval', as: 'pending_approval'

  namespace :trader do
    resource :portfolios, only: [:show]
    resources :stocks, param: :symbol, only: [:index, :show]
    resources :transactions, only: [:index, :show, :new] do
      collection do
        post 'buy'
        post 'sell'
      end
    end
  end

  namespace :admin do
    resources :users, only: [:create, :index, :show, :new, :update, :edit, :destroy] do
      collection do
        get 'pending'
      end
      member do
        patch 'approve'
      end
    end
    resources :transactions, only: [:index]
  end
end