require 'rails_helper'

RSpec.describe Admin::VideosController do
  login_admin
  let(:videoable) { create(:find_the_best_location) }
  let(:definition) { create(:definition) }

  describe 'POST create' do
    it 'generates new video' do
      video_generator = instance_double(VideoGenerator)
      expect(video_generator).to receive(:generate)
      expect(VideoGenerator).to receive(:new).with(videoable, definition) { video_generator }
      post :create, find_the_best_location_id: videoable.id, video: { definition_id: definition.id }
      expect(response).to redirect_to(admin_find_the_best_location_url(videoable))
    end
  end
end
