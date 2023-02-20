Rails.application.routes.draw do
  root "games#index"

  resources :games do
    resources :generations do
      get 'next', to: 'generations#next'
      get 'previous', to: 'generations#previous'
    end
  end
  
  resources :articles do
    resources :comments
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
