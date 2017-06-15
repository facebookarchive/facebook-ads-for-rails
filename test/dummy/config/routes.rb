# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

Rails.application.routes.draw do
  post '/facebook/update_settings', to: 'facebook_settings#update_settings'
  resources :simple_products
  get 'admin', to: "admin#index"
  root "simple_products#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
