require 'rails_helper'
require 'controllers/shared_examples/crud_controller_examples'

RSpec.describe Admin::SceneCollectionsController do
  it_behaves_like 'CRUD controller', SceneCollection
end
