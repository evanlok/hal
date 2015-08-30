require 'rails_helper'

RSpec.describe Admin::CsvImportsController do
  login_admin

  describe 'GET index' do
    it 'renders page' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'POST core_logic' do
    let!(:definition) { create(:definition, name: Importers::CoreLogicLocationCSVImporter::DEFINITION_NAME) }

    it 'imports csv file' do
      expect_any_instance_of(Importers::CoreLogicLocationCSVImporter).to receive(:import)
      post :core_logic, csv: { file: fixture_file_upload('files/ftb_data.csv', 'text/csv') }
      expect(response).to redirect_to(admin_csv_imports_url)
    end
  end
end
