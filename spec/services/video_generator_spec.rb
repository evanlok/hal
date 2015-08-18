require 'rails_helper'

RSpec.describe VideoGenerator do
  let(:video_content) { create(:video_content) }
  let(:video_generator) { VideoGenerator.new(video_content) }

  describe '#generate' do
    let(:video) { build_stubbed(:video) }

    before do
      expect(video_generator).to receive(:fetch_video) { video }
      expect(VGLGenerator).to receive(:new).with(video_content) { double(:vgl_generator) }
      expect(OnvedeoVideoEncoder).to receive(:new).with(video) { double(:encoder) }
    end

    context 'with FindTheBestLocation' do
      let(:video_content) { create(:find_the_best_location) }

      it 'posts video to VidgenieClient' do
        expect_any_instance_of(VidgenieClient).to receive(:post_to_server)
        video_generator.generate
      end
    end

    it 'posts video to VidgenieClient' do
      expect_any_instance_of(VidgenieClient).to receive(:post_to_server)
      video_generator.generate
    end

    context 'with stream_only' do
      it 'calls generate with stream_only' do
        expect_any_instance_of(VidgenieClient).to receive(:post_to_server).with(stream_only: true)
        video_generator.generate(stream_only: true)
      end
    end
  end

  describe '#fetch_video' do
    context 'when video does not exist' do
      it 'creates video' do
        expect { video_generator.fetch_video }.to change { Video.count }.by(1)
      end
    end

    context 'when video already exists' do
      let!(:video) { create(:video, videoable: video_content) }

      it 'fetches existing video' do
        expect(video_generator.fetch_video).to eq(video)
      end
    end
  end
end
