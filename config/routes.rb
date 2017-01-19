Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations', confirmations: 'confirmations' } # Use custom class for registration
  resources :events
  resources :categories
  root :to => 'static_pages#home'
end
