Rails.application.routes.draw do
  root to: 'admin/definitions#index'

  devise_for :users

  resources :find_the_best_locations, only: [] do
    member do
      get :embed
    end
  end

  get '/fth_videos/:ftb_id', to: 'find_the_best_locations#fth_embed', as: 'fth_video'

  resource :encoder_callback, only: [:create]

  namespace :admin do
    root to: 'definitions#index'

    concern :videoable do
      resource :video, only: [:create]
    end

    resources :definitions

    resources :find_the_best_locations, concerns: :videoable do
      collection do
        post :import
      end
    end
  end
end
