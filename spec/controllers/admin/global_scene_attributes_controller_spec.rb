require 'rails_helper'
require 'controllers/shared_examples/crud_controller_examples'

RSpec.describe Admin::GlobalSceneAttributesController do
  it_behaves_like 'CRUD controller', GlobalSceneAttribute do
    let(:create_params) { attributes_for(:global_scene_attribute).merge(scene_attribute_type_id: create(:scene_attribute_type).id) }
    let(:create_redirect_url) { { action: :index } }
    let(:update_redirect_url) { { action: :index } }
  end
end
