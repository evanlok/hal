require 'rails_helper'

RSpec.describe CallbacksController do
  let(:video) { create(:video) }

  describe 'POST encoder' do
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

    it 'updates video' do
      post :encoder, payload.merge(video_id: video.id)
      expect(response).to be_success
      video.reload
      expect(video.filename).to eq('video.mp4')
    end
  end

  describe 'POST stream' do
    let(:video) { create(:video, stream_url: nil) }

    it 'updates video stream url' do
      post :stream, video_id: video.id, stream: { url: 'stream_url', reference: { video_id: video.id } }
      expect(response).to be_success
      expect(video.reload.stream_url).to eq('stream_url')
    end
  end
end
