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
    it 'creates new SceneCollection and triggers generation' do
      post :create, scene_collection.data.merge(format: :json)
      expect(response).to have_http_status(:created)
      expect(assigns(:scene_collection).data).to eq(scene_collection.data)
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

  describe 'POST generate' do
    it 'triggers video generation' do
      expect_any_instance_of(SceneCollection).to receive(:generate) { true }
      post :generate, id: scene_collection.id
      expect(response).to be_success
    end
  end

  describe 'POST preview' do
    it 'triggers preview generation' do
      expect_any_instance_of(SceneCollection).to receive(:preview) { true }
      post :preview, id: scene_collection.id
      expect(response).to be_success
    end
  end
end
