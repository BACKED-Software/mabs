Rails.application.routes.draw do
  
  root "main#index"

  match 'events', to: "events#index", via: :get
  match 'announcements', to: "announcements#index", via: :get

  #define the events resources routes
  resources :events do
    #special route for deleting events
    member do
      get 'delete'
    end
  end

  #define the announcements resources routes
  resources :announcements do
    #special route for deleting events
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
