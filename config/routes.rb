Rails.application.routes.draw do
  # Devise authentication
  devise_for :users
  
  # Root path
  root "home#index"
  
  # Authenticated routes
  authenticate :user do
    resources :snippets do
      member do
        patch :toggle_visibility
        get :raw
      end
      collection do
        get :search
      end
    end
    
    resources :tags, except: [:show]
    
    resources :collections do
      resources :snippets, only: [:index, :create, :destroy], controller: 'collection_snippets'
    end
    
    # User profile
    get 'profile', to: 'users#profile', as: :user_profile
    get 'profile/edit', to: 'users#edit', as: :edit_user_profile
    patch 'profile', to: 'users#update'
  end
  
  # Public routes
  namespace :public do
    resources :snippets, only: [:index, :show] do
      collection do
        get :search
      end
    end
    resources :collections, only: [:index, :show]
    resources :users, only: [:show], param: :username
  end
  
  # API routes for future use
  namespace :api do
    namespace :v1 do
      resources :snippets, only: [:index, :show]
    end
  end
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
  
  # PWA
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end