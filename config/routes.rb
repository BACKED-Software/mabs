# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end
  # dashboard route
  root to: 'dashboard#index'
  
  # define the events resources routes
  
  resources :events do
    # special route for deleting events
    member do
      get 'delete'
    end
  end
  
  # define the announcements resources routes
  resources :announcements do
    # special route for deleting events
    member do
      get 'delete'
    end
  end
  resources :admin, only: [:index, :create, :update]
  # get 'admin/index'
  # post 'admin/users', to: 'admin#create', as: 'admin_users'
  # patch '/admin/users/:id', to: 'admin#update', as: 'admin_user'
end
