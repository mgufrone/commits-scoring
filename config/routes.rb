require "sidekiq/web"
require 'sidekiq/cron/web'
Rails.application.routes.draw do

  get 'payload/receive'

  mount Sidekiq::Web => '/sidekiq'
  devise_for :user
  get '/auth/:provider/callback', to: 'omniauth#create'
  use_doorkeeper do
   controllers applications: 'oauth_app'
  end
  root 'dashboard#index'
end
