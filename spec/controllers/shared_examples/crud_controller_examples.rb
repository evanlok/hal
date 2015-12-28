require 'rails_helper'

RSpec.shared_examples 'CRUD controller' do |klass, exclude = []|
  login_admin
  let(:factory_name) { klass.model_name.singular }
  let(:resource) { create(factory_name) }
  let(:param_key) { klass.model_name.param_key }
  let(:singular_name) { klass.model_name.singular }
  let(:create_redirect_url) { { action: :edit, id: assigns(singular_name).id } }
  let(:update_redirect_url) { { action: :edit, id: resource.id } }
  let(:destroy_redirect_url) { { action: :index } }
  let(:default_params) { {} }
  let(:parent_resource) {}
  let(:create_params) { attributes_for(factory_name) }

  before do
    if parent_resource
      default_params.merge!("#{parent_resource.model_name.singular}_id" => parent_resource)
    end
  end

  describe 'GET index', if: exclude.exclude?(:index) do
    it 'renders page' do
      get :index, default_params
      expect(response).to be_success
    end
  end

  describe 'GET new', if: exclude.exclude?(:new) do
    it 'renders page' do
      get :new, default_params
      expect(response).to be_success
    end
  end

  describe 'POST create', if: exclude.exclude?(:create) do
    it "creates new #{klass.model_name.name}" do
      post :create, default_params.merge(param_key => create_params)
      expect(assigns(singular_name)).to be_persisted
      expect(response).to redirect_to(create_redirect_url)
    end
  end

  describe 'GET edit', if: exclude.exclude?(:edit) do
    it 'renders page' do
      get :edit, default_params.merge(id: resource)
      expect(response).to be_success
    end
  end

  describe 'PATCH update', if: exclude.exclude?(:update) do
    it "updates #{klass.model_name.name}" do
      patch :update, default_params.merge(id: resource, param_key => attributes_for(factory_name))
      expect(response).to redirect_to(update_redirect_url)
    end
  end

  describe 'DELETE destroy', if: exclude.exclude?(:destroy) do
    it "deletes #{klass.model_name.name}" do
      delete :destroy, default_params.merge(id: resource)
      expect(klass.where(id: resource.id)).to_not exist
      expect(response).to redirect_to(destroy_redirect_url)
    end
  end
end
