# frozen_string_literal: true

Rails.application.routes.draw do
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

  # get 'announcements/index'
  # get 'announcements/show'
  # get 'announcements/new'
  # get 'announcements/edit'
  # get 'announcements/delete'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
