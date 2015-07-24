require 'rails_helper'

RSpec.describe FindTheBestLocationsController do
  let!(:find_the_best_location) { create(:find_the_best_location) }
  let!(:video) { create(:video, videoable: find_the_best_location) }

  describe 'GET embed' do
    it 'renders page' do
      get :embed, id: find_the_best_location
      expect(response).to be_success
      expect(response).to render_template('embed')
      expect(response).to render_template('layouts/embed')
      expect(response.headers.keys).to_not include('X-Frame-Options')
    end
  end

  describe 'GET fth_embed' do
    it 'finds record by ftb_id and renders page' do
      get :fth_embed, ftb_id: find_the_best_location.ftb_id
      expect(response).to be_success
      expect(response).to render_template('embed')
      expect(response).to render_template('layouts/embed')
      expect(response.headers.keys).to_not include('X-Frame-Options')
    end
  end
end
