require 'rails_helper'
require 'controllers/shared_examples/crud_controller_examples'

RSpec.describe Admin::ScenesController do
  it_behaves_like 'CRUD controller', Scene
end
