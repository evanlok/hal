Rails.application.routes.draw do
  root to: 'admin/definitions#index'

  devise_for :users

  namespace :admin do
    root to: 'definitions#index'

    resources :definitions
  end
end
