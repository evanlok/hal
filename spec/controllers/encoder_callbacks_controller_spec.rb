require 'rails_helper'

RSpec.describe EncoderCallbacksController do
  let!(:video) { create(:video) }
  let(:url) { 'http://www.houztrendz.com/video.mp4' }
  let(:payload) do
    {
      status: 'finished',
      outputs: [
        { label: 'medium', url: url }
      ],
      input: { duration_in_ms: 1000 },
      reference_id: video.id
    }
  end

  describe 'POST create' do
    it 'updates video' do
      post :create, payload
      expect(response).to be_success
      video.reload
      expect(video.filename).to eq('video.mp4')
    end
  end
end
