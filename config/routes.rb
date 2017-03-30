Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations', confirmations: 'confirmations' } # Use custom class for registration
  resources :events
  resources :categories


  devise_scope :user do
    get '/users' => 'events#index'
  end

  root :to => 'static_pages#home'
end
