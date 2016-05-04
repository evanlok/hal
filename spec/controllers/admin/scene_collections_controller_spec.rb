require 'rails_helper'
require 'controllers/shared_examples/crud_controller_examples'

RSpec.describe Admin::SceneCollectionsController do
  login_admin
  it_behaves_like 'CRUD controller', SceneCollection

  let(:scene_collection) { create(:scene_collection) }

  describe 'POST preview' do
    it 'creates VideoPreview' do
      expect_any_instance_of(VideoPreviewer).to receive(:create_video_preview) { double(:video_preview, id: 10) }
      post :preview, id: scene_collection.id
      expect(response).to be_success
    end

    context 'when preview has errors' do
      it 'returns bad request' do
        expect_any_instance_of(VideoPreviewer).to receive(:create_video_preview) { false }
        post :preview, id: scene_collection.id
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
