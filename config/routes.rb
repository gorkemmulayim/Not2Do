Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome/index'

  resources :users
  resources :sessions

  get 'profile', to: 'users#current_user_profile'
  get 'profile/:id', to: 'users#show'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
