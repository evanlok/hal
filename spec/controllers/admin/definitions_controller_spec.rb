require 'rails_helper'

RSpec.describe Admin::DefinitionsController do
  login_admin
  let(:video_type) { create(:video_type) }
  let(:definition) { create(:definition) }

  describe 'GET index' do
    it 'renders page' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET new' do
    it 'renders page' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    it 'creates new definition' do
      post :create, definition: attributes_for(:definition, video_type_id: video_type.id)
      expect(assigns(:definition)).to be_persisted
      expect(response).to redirect_to(admin_definitions_url)
    end
  end

  describe 'GET edit' do
    it 'renders page' do
      get :edit, id: definition
      expect(response).to be_success
    end

    with_versioning do
      before do
        definition.update(name: 'New Name')
      end

      it 'loads version from version_id' do
        get :edit, id: definition.id, version_id: definition.versions.last.id
        expect(assigns(:definition).version).to be_present
        expect(assigns(:versions)).to be_present
        expect(response).to be_success
      end
    end
  end

  describe 'PATCH update' do
    it 'updates definition' do
      patch :update, id: definition, definition: { name: 'New Name' }
      definition.reload
      expect(definition.name).to eq('New Name')
      expect(response).to redirect_to(edit_admin_definition_url(definition))
    end
  end

  describe 'DELETE destroy' do
    it 'deletes definition' do
      delete :destroy, id: definition
      expect(Definition.where(id: definition.id)).to_not exist
      expect(response).to redirect_to(admin_definitions_url)
    end
  end
end
