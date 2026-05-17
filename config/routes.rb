Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :users, only: [:index,:show,:create,:update,:destroy]
  resources :tweets, only: [:index, :show, :create, :destroy]
  resoucres :like, only: [:create, :destroy]
  resources :users do
    post "follow", to: "follows#create"
    delete "unfollow/:id", to: "follows#destroy"
  end

  get "/confirm", to: "users#confirm"
  post "/login", to: "auth#login"
end
