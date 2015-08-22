require 'rails_helper'

RSpec.describe Admin::VideosController do
  login_admin
  let(:video_content) { create(:video_content) }

  describe 'POST create' do
    it 'generates new video' do
      video_generator = instance_double(VideoGenerator)
      expect(video_generator).to receive(:generate)
      expect(VideoGenerator).to receive(:new).with(video_content) { video_generator }
      post :create, video_content_id: video_content.id
      expect(response).to redirect_to(admin_video_content_url(video_content))
    end
  end

  describe 'POST create_preview' do
    let!(:video) { create(:video, videoable: video_content) }

    it 'generates new preview video' do
      video_generator = instance_double(VideoGenerator)
      expect(video_generator).to receive(:generate).with(stream_only: true)
      expect(VideoGenerator).to receive(:new).with(video_content) { video_generator }
      post :create_preview, video_content_id: video_content.id
      expect(response).to redirect_to(video_url(video, autoplay: 1))
    end
  end
end
