Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # Defines the root path route ("/")
  root "users#index", to: "users#index"
  # show user profile
  get 'profile/:id', to: 'users#profile', as: 'profile'
  # search user profile, by email
  get 'profile', to: 'users#search_profile', as: 'search_profile'
  # manage users conversations
  get 'manage_users', to: 'users#manage_users'
  # conversations actions
  resources :conversations, only: [:show, :create, :destroy ] do
    # messages unread count reset to 0 if user is viewed
    post :unread_messages_reset, on: :member, as: :unread_messages_reset
    # only create message
    resources :messages, only: [:create, :destroy]
  end
  # redirect to root page if undefined path and add constraints except active storage routes [to handle AWS S3 requests]
  match '*unmatched', to: 'application#not_found_method', via: [:get, :post, :put, :patch, :delete], constraints: lambda { |req| req.path.exclude?('/rails/active_storage') }
end
