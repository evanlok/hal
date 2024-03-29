Rails.application.routes.draw do
  root to: 'admin/definitions#index'

  devise_for :users

  resources :find_the_best_locations, only: [] do
    member do
      get :embed
    end
  end

  resources :videos, only: :show do
    get :stream, on: :member
  end

  resources :video_previews, only: :show

  get '/fth_videos/:ftb_id', to: 'find_the_best_locations#fth_embed', as: :fth_video

  scope '/callbacks/:video_id' do
    post 'encoder', to: 'callbacks#encoder', as: :encoder_callback
    post 'stream', to: 'callbacks#stream', as: :stream_callback
    post 'preview', to: 'callbacks#preview', as: :preview_callback
  end

  namespace :admin do
    root to: 'definitions#index'

    concern :videoable do
      resource :video, only: [:create] do
        post :create_preview, on: :collection
      end
    end

    resources :video_types
    resources :definitions
    resources :video_contents, concerns: :videoable
    resources :videos, only: [:index]

    resources :scenes do
      post :preview, on: :collection
      resources :scene_attributes
    end

    resources :scene_collections do
      post :preview, on: :member
    end

    resources :scene_attribute_types
    resources :global_scene_attributes

    resources :find_the_best_locations, concerns: :videoable do
      collection do
        post :import
      end
    end

    resources :csv_imports, only: [:index] do
      collection do
        post :core_logic
      end
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :video_contents, only: [:create, :show]
      resources :scenes, only: [:index, :show]
      resources :scene_collections, only: [:show, :create, :update, :destroy] do
        member do
          post :generate
          post :preview
        end
      end
    end
  end
end
