require 'rails_helper'

RSpec.describe VideoGenerator do
  let(:videoable) { create(:find_the_best_location) }
  let(:definition) { create(:definition) }
  let(:video_generator) { VideoGenerator.new(videoable, definition) }

  describe '#generate' do
    let(:video) { build(:video) }

    it 'posts video to VidgenieClient' do
      expect(video_generator).to receive(:fetch_video) { video }
      expect(VidgenieClient).to receive(:post_video).with(video, 'normal')
      video_generator.generate
    end
  end

  describe '#fetch_video' do
    context 'when video does not exist' do
      it 'creates video' do
        expect { video_generator.fetch_video }.to change { Video.count }.by(1)
      end
    end

    context 'when video already exists' do
      let!(:video) { create(:video, videoable: videoable) }

      it 'fetches existing video' do
        expect(video_generator.fetch_video).to eq(video)
        expect(video_generator.fetch_video.definition).to eq(definition)
      end
    end
  end
end
