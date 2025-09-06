Rails.application.routes.draw do
  # Devise authentication
  devise_for :users
  
  # Root path - redirect to feed
  root "public/snippets#feed"
  
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
      resources :comments, only: [:create, :destroy]
      resources :stars, only: [:create, :destroy]
      resource :star, only: [:create, :destroy]
    end
    
    resources :tags, except: [:show]
    
    resources :collections do
      resources :snippets, only: [:index, :create, :destroy], controller: 'collection_snippets'
    end
    
    resources :stacks do
      member do
        post 'add_snippet'
        delete 'remove_snippet/:snippet_id', action: 'remove_snippet', as: 'remove_snippet'
      end
    end
    
    # User profile
    get 'profile', to: 'users#profile', as: :user_profile
    get 'profile/edit', to: 'users#edit', as: :edit_user_profile
    patch 'profile', to: 'users#update'
    
    # Notifications
    resources :notifications, only: [:index] do
      member do
        patch :mark_as_read
      end
      collection do
        patch :mark_all_as_read
      end
    end
    
    # Notification Settings
    resource :notification_settings, only: [:show, :update]
  end
  
  # Public routes (accessible without authentication)  
  get 'feed', to: 'public/snippets#feed', as: :feed
  get 'snippets/browse', to: 'public/snippets#index', as: :public_snippets
  get 'snippets/browse/:id', to: 'public/snippets#show', as: :public_snippet
  get 'snippets/browse/search', to: 'public/snippets#search', as: :public_snippets_search
  post 'snippets/browse/:snippet_id/comments', to: 'public/comments#create', as: :public_snippet_comments
  delete 'snippets/browse/:snippet_id/comments/:id', to: 'public/comments#destroy', as: :public_snippet_comment
  post 'snippets/browse/:snippet_id/star', to: 'public/stars#create', as: :public_snippet_star
  delete 'snippets/browse/:snippet_id/star', to: 'public/stars#destroy', as: :public_snippet_unstar
  
  # Temporary snippet creation for unauthenticated users
  get 'create', to: 'snippets#new', as: :create_snippet
  post 'create', to: 'snippets#create_temporary'
  
  namespace :public do
    resources :snippets, only: [:index, :show] do
      collection do
        get :search
      end
    end
    resources :collections, only: [:index, :show]
    resources :stacks, only: [:index, :show]
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