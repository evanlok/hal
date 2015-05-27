Rails.application.routes.draw do
  root to: 'admin/definitions#index'

  devise_for :users

  resource :encoder_callback, only: [:create]

  namespace :admin do
    root to: 'definitions#index'

    resources :definitions
    resources :find_the_best_locations
  end
end
