Rails.application.routes.draw do
  get '/users', to: 'users#index'
  get '/users/:phone', to: 'users#show_by_phone'
  post '/users', to: 'users#create'
  put '/users/:phone', to: 'users#update'
  delete '/users/:phone', to: 'users#destroy'
end
