Rails.application.routes.draw do

  devise_for :users
  resources :events
  root 'static_pages#home'
end
