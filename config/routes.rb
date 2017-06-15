# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

Rails.application.routes.draw do
  get '/facebook/product_feed', to: 'facebook_product_feed#index'
  get '/facebook/product_feed_ping', to: 'facebook_product_feed#ping'
end