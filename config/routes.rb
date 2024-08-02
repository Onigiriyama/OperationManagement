Rails.application.routes.draw do
  root "directs#new"
  
  resources :directs, only: [:new, :create, :index]
end