Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' } # Use custom class for registration
  resources :events
  resources :categories
  root 'static_pages#home'
end
