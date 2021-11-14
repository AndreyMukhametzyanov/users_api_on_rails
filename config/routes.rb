Rails.application.routes.draw do
  resources :users, param: :phone
  # get '/users', to: 'users#index'
  # get '/users/:phone', to: 'users#show'
  # post '/users', to: 'users#create'
  # put '/users/:phone', to: 'users#update'
  # delete '/users/:phone', to: 'users#destroy'
end
