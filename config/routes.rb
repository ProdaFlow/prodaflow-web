Rails.application.routes.draw do
  get 'users/new'

  root   'pages#show', page: 'home'

  get    '/pages/:page' => 'pages#show'
  # Sessions
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users
end
