Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: [:index] do
    # for profile
    get 'profile', to: 'users#search_profile', on: :member
    get 'profile/:id', to: 'users#profile'
    get 'manage_users', to: 'users#manage_users', on: :member
    # for remove user from chat list
    resources :conversations, only: [:show, :create, :destroy ] do
      post :unread_messages_reset, on: :member, as: :unread_messages_reset
      resources :messages, only: [:create]
    end
  end
  get 'profile', to: 'users#profile'

  # Defines the root path route ("/")
  root "users#index"

  match '*unmatched', to: 'application#not_found_method', via: :all
end
