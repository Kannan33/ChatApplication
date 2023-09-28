Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: [:index] do
    # search user profile
    get 'profile', to: 'users#search_profile', on: :member
    get 'profile/:id', to: 'users#profile'
    # manage users conversations
    get 'manage_users', to: 'users#manage_users', on: :member
    # for remove user from chat list
    resources :conversations, only: [:show, :create, :destroy ] do
      # messages unread count reset to 0 if user is viewed
      post :unread_messages_reset, on: :member, as: :unread_messages_reset
      resources :messages, only: [:create]
    end
  end
  # current user profile
  get 'profile', to: 'users#profile'

  # Defines the root path route ("/")
  root "users#index"
  # redirect to root page if undefined path and add constraints except active storage routes [to handle AWS S3 requests]
  match '*unmatched', to: 'application#not_found_method', via: [:get, :post, :put, :patch, :delete], constraints: lambda { |req| req.path.exclude?('/rails/active_storage') }
end
