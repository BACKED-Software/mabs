Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  #define the events resources routes
  resources :events do
    #special route for deleting events
    member do
      get 'delete'
    end
  end
end
