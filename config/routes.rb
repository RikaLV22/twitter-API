Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [:index, :show, :create, :update, :destroy]

  resources :tweets, only: [:index, :show, :create, :destroy] do
    post :reply, on: :member
    post :like, to: "likes#create"
    delete :like, to: "likes#destroy"

    post :retweet, to: "retweets#create"
    delete :retweet, to: "retweets#destroy"
  end

  resources :users do
    post "follow", to: "follows#create"
    delete "unfollow/:id", to: "follows#destroy"
  end

  post "/login", to: "auth#login"
  get "/confirm", to: "users#confirm"
end