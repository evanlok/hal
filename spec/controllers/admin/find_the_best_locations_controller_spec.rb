require 'rails_helper'

RSpec.describe Admin::FindTheBestLocationsController do
  login_admin
  let(:find_the_best_location) { create(:find_the_best_location) }

  describe 'GET index' do
    it 'renders page' do
      expect(response).to be_success
    end
  end

  describe 'GET show' do
    it 'renders page' do
      get :show, id: find_the_best_location
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
    it 'creates new record' do
      post :create, find_the_best_location: { ftb_id: 1234, county: 'County' }
      expect(assigns(:find_the_best_location)).to be_persisted
      expect(response).to redirect_to(admin_find_the_best_locations_url)
    end
  end

  describe 'GET edit' do
    it 'renders page' do
      expect(response).to be_success
    end
  end

  describe 'PATCH update' do
    it 'updates record' do
      patch :update, id: find_the_best_location, find_the_best_location: { county: 'Another county' }
      find_the_best_location.reload
      expect(find_the_best_location.county).to eq('Another county')
      expect(response).to redirect_to(admin_find_the_best_locations_url)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes record' do
      delete :destroy, id: find_the_best_location
      expect(FindTheBestLocation.where(id: find_the_best_location.id)).to_not exist
      expect(response).to redirect_to(admin_find_the_best_locations_url)
    end
  end

  describe 'POST import' do
    it 'runs importer for file' do
      expect_any_instance_of(Importers::FindTheBestLocationCSVImporter).to receive(:import)
      post :import, csv: { file: fixture_file_upload('files/ftb_data.csv', 'text/csv') }
      expect(response).to redirect_to(admin_find_the_best_locations_url)
    end
  end
end
