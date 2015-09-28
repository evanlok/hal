require 'rails_helper'

RSpec.describe VideosController do
  describe 'GET show' do
    let(:video) { create(:video) }

    it 'renders page' do
      get :show, id: video
      expect(response).to be_success
      expect(response).to render_template('embed')
    end
  end
end
