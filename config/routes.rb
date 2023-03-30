Rails.application.routes.draw do
  resources :games, only: [:create]
  post '/rolls', to: "games#rolls"
  get '/game', to: "games#show"
end
