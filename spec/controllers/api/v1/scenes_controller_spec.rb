require 'rails_helper'

RSpec.describe Api::V1::ScenesController do
  let!(:scene) { create(:scene) }

  describe 'GET index' do
    it 'renders scene collection' do
      get :index, format: :json
      expect(response).to be_success
      expect(assigns(:scenes)).to eq([scene])
    end
  end

  describe 'GET show' do
    it 'renders scene' do
      get :show, id: scene.id, format: :json
      expect(response).to be_success
      expect(assigns(:scene)).to eq(scene)
    end
  end
end
