require 'rails_helper'

RSpec.describe Admin::DefinitionsController do
  login_admin
  let(:definition) { create(:definition) }

  describe 'GET index' do
    it 'renders page' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET new' do
    it 'renders page' do
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    it 'creates new definition' do
      post :create, definition: attributes_for(:definition)
      expect(assigns(:definition)).to be_persisted
      expect(response).to redirect_to(admin_definitions_url)
    end
  end

  describe 'GET edit' do
    it 'renders page' do
      expect(response).to be_success
    end
  end

  describe 'PATCH update' do
    it 'updates definition' do
      patch :update, id: definition, definition: { name: 'New Name'}
      definition.reload
      expect(definition.name).to eq('New Name')
      expect(response).to redirect_to(admin_definitions_url)
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
