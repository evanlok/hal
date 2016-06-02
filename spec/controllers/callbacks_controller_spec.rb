require 'rails_helper'

RSpec.describe CallbacksController do
  let(:scene_collection) { create(:scene_collection) }
  let(:video) { create(:video, videoable: scene_collection) }

  describe 'POST encoder' do
    let(:payload) do
      {
        status: 'finished',
        outputs: [
          { label: 'medium', url: 'http://www.houztrendz.com/video_360.mp4', thumbnail: { url: 'thumbnail_360.jpg' } },
          { label: 'high', url: 'http://www.houztrendz.com/video_720.mp4', thumbnail: { url: 'thumbnail_720.jpg' } },
        ],
        input: { duration_in_ms: 10000 },
        reference_id: video.id
      }
    end

    it 'updates video and sends callback notification' do
      expect(Notifiers::VideoCallbackNotifier).to receive(:notify).with(video)
      post :encoder, payload.merge(video_id: video.id)
      expect(response).to be_success
      video.reload
      expect(video).to have_attributes(filename: 'video.mp4', duration: 10, thumbnail_url: 'thumbnail_720.jpg')
    end
  end

  describe 'POST stream' do
    let(:video) { create(:video, stream_url: nil) }

    it 'updates video stream url' do
      expect(Notifiers::StreamCallbackNotifier).to receive(:notify).with(video)
      post :stream, video_id: video.id, stream: { url: 'stream_url', reference: { video_id: video.id } }
      expect(response).to be_success
      expect(video.reload.stream_url).to eq('stream_url')
    end
  end

  describe 'POST preview' do
    let!(:video_preview) { create(:video_preview, previewable: scene_collection) }

    it 'updates video preview stream_url' do
      expect(Notifiers::PreviewCallbackNotifier).to receive(:notify).with(video_preview)
      post :preview, video_id: video_preview.id, stream: { url: 'stream_url' }
      expect(response).to be_success
      expect(video_preview.reload).to have_attributes(stream_url: 'stream_url')
    end
  end
end
