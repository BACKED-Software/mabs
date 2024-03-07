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
  get '/admin/upcoming_events', to: 'admin#upcoming_events'
  get '/admin/event/:id', to: 'admin#event', as: 'admin_event'
  get '/admin/demographics', to: 'admin#demographics'
  
  patch '/admin-tools/:id/promote_to_admin', to: 'admin#promote_to_admin', as: 'promote_to_Admin'
  delete '/admin-tools/:id/destroy', to: 'admin#destroy', as: 'destroy_user'

  resources :admin do
    member do
      # get 'make_admin'
      # patch 'update'
      # delete 'destroy'
    end
  end

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

  resources :attendances do
    member do
      get 'delete'
    end
  end

  post 'award_points', to: 'points#award', as: 'award_points'

  get 'manage_points', to: 'points#manage', as: 'manage_points'

  # config/routes.rb
  post 'points/save_changes', to: 'points#save_changes', as: :save_changes_points

  resources :points do
    member do
      get 'delete'
    end
  end

  get 'points_history', to: 'users#points_history', as: 'points_history'

  resources :rsvps, only: %i[index create destroy]

  get 'leaderboard/index'
  get 'dashboard/index'
end
