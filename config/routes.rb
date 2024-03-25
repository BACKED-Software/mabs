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
  get '/admin/demographics', to: 'admin#index', as: 'admin_demographics'

  get '/admin-tools/:id/promote_to_admin', to: 'admin#promote_to_admin', as: 'promote_to_admin'
  get '/admin-tools/:id/demote_to_user', to: 'admin#demote_to_user', as: 'demote_to_user'
  get '/admin-tools/:id/destroy', to: 'admin#destroy', as: 'destroy_user'
  get 'admin/export_demographics', to: 'admin#export_demographics', as: 'export_demographics'

  resources :admin do
    member do
      # get 'make_admin'
      # patch 'update'
      # delete 'destroy'
      get 'delete'
      get 'promote_to_admin'
      get 'demote_to_user'
      # get 'export_demographics'
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
      get 'destroy'
    end
  end

  delete 'points/:id/destroy', to: 'points#destroy', as: 'destroy_points'

  resources :rsvps, only: %i[index create destroy]

  get 'leaderboard/index'
  get 'dashboard/index'

  post 'recalculate_points', to: 'admin#recalculate_points'
  # config/routes.rb
  post 'backup_database', to: 'admin#backup_database', as: :backup_database
  get 'list_backups', to: 'admin#list_backups', as: :list_backups
  get 'download_backup', to: 'admin#download_backup', as: :download_backup
  get 'delete_backup', to: 'admin#delete_backup', as: :delete_backup
  post 'import_backup', to: 'admin#import_backup', as: :import_backup
end
