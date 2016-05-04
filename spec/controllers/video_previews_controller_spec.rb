require 'rails_helper'

RSpec.describe VideoPreviewsController do
  let(:video_preview) { create(:video_preview) }

  describe 'GET show' do
    it 'renders page' do
      get :show, id: video_preview.id
      expect(assigns(:video_preview)).to be_present
      expect(response).to be_success
    end

    context 'as json' do
      it 'renders json with stream url' do
        get :show, id: video_preview.id, format: :json
        expect(response).to be_success
        expect(response.content_type).to eq('application/json')
        expect(JSON.parse(response.body)['stream_url']).to eq(video_preview.stream_url)
      end
    end
  end
end
