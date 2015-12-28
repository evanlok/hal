require 'rails_helper'
require 'controllers/shared_examples/crud_controller_examples'

RSpec.describe Admin::SceneAttributeTypesController do
  it_behaves_like 'CRUD controller', SceneAttributeType do
    let(:create_redirect_url) { { action: :index } }
    let(:update_redirect_url) { { action: :index } }
  end
end
