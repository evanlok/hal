require 'rails_helper'

RSpec.describe Api::V1::SceneCollectionsController do
  let(:scene_collection) { create(:scene_collection) }

  describe 'GET show' do
    it 'renders json' do
      get :show, id: scene_collection, format: :json
      expect(response).to be_success
      expect(response.content_type).to eq('application/json')
    end
  end

  describe 'POST create' do
    it 'creates new record' do
      post :create, scene_collection.data.merge(format: :json)
      expect(response).to have_http_status(:created)
      expect(assigns(:scene_collection).data).to eq(scene_collection.data)
    end

    it 'triggers video generation' do
      pending
    end
  end

  describe 'PATCH update' do
    let(:existing_scene_collection) { create(:scene_collection, data: {}) }

    it 'updates existing scene collection' do
      patch :update, scene_collection.data.merge(id: existing_scene_collection, format: :json)
      expect(response).to be_success
      expect(assigns(:scene_collection).data).to eq(scene_collection.data)
    end
  end
end
