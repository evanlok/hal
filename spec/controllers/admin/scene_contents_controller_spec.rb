require 'rails_helper'
require 'controllers/shared_examples/crud_controller_examples'

RSpec.describe Admin::SceneContentsController do
  it_behaves_like 'CRUD controller', SceneContent, [:index] do
    let(:scene_collection) { create(:scene_collection) }
    let(:parent_resource) { scene_collection }
    let(:create_params) { attributes_for(:scene_content).merge(scene_id: create(:scene).id) }
    let(:destroy_redirect_url) { admin_scene_collection_url(scene_collection) }
  end
end
