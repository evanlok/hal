require 'rails_helper'
require 'controllers/shared_examples/crud_controller_examples'

RSpec.describe Admin::ScenesController do
  login_admin

  it_behaves_like 'CRUD controller', Scene

  describe 'POST preview' do
    let(:scene) { create(:scene, vgl_content: "b.text('TEXT')") }

    it 'creates VideoPreview for scene' do
      expect_any_instance_of(Scene).to receive(:preview).with(definition: kind_of(Engine::Definitions::ScenePreviewVideo)) { double(:video_preview, id: 10) }
      post :preview, scene_id: scene.id, scene_vgl: scene.vgl_content, scene_data: {}.to_json
      expect(response).to be_success
    end

    context 'when preview has errors' do
      it 'returns bad request status' do
        expect_any_instance_of(Scene).to receive(:preview).with(definition: kind_of(Engine::Definitions::ScenePreviewVideo)) { false }
        post :preview, scene_id: scene.id, scene_vgl: scene.vgl_content, scene_data: {}.to_json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
