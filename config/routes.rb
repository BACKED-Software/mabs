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
  get '/admin-tools', to: 'admin#index'

  resources :events do
    # special route for deleting events
    member do
      get 'delete'
    end
  end

  # define the announcements resources routes
  resources :announcements do
    # special route for deleting announcements
    member do
      get 'delete'
    end
  end

  resources :users do
    # special route for deleting users
    member do
      get 'delete'
      patch 'make_admin'
    end
  end

  get 'dashboard/index'
end
