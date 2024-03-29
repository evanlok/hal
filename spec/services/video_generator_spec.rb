require 'rails_helper'

RSpec.describe VideoGenerator do
  let(:video_content) { double(:content, id: 123) }
  let(:definition) { double(:definition, video_content: video_content, to_vgl: 'vgl', width: 1280, height: 720) }
  subject { VideoGenerator.new(definition) }

  describe '#generate' do
    context 'when vgl is invalid' do
      it 'returns false' do
        expect(subject).to receive(:valid?) { false }
        expect(subject.generate).to be false
      end
    end

    it 'creates video record and posts video to vidgenie API' do
      expect(subject).to receive(:payload) { 'params' }
      expect_any_instance_of(VidgenieAPIClient).to receive(:post_video).with('params')
      expect(video_content).to receive(:videos) { double(:videos, create: double(:video)) }
      subject.generate
    end

    it 'creates Video with callback_url and stream_callback_url' do
      expect(subject).to receive(:payload) { 'params' }
      expect_any_instance_of(VidgenieAPIClient).to receive(:post_video).with('params')
      videos_association = double(:videos)
      expect(video_content).to receive(:videos) { videos_association }
      expect(videos_association).to receive(:create).with(callback_url: 'callback', stream_callback_url: 'stream', resolutions: kind_of(Hash))
      subject.generate(callback_url: 'callback', stream_callback_url: 'stream')
    end
  end

  describe '#valid?' do
    it 'returns true when vgl is valid' do
      expect(subject.valid?).to be true
    end

    context 'when vgl has build errors' do
      it 'returns false and sets errors' do
        expect(definition).to receive(:to_vgl).and_raise(StandardError, 'error message')
        expect(subject.valid?).to be false
        expect(subject.errors.count).to eq(2)
        expect(subject.errors[0]).to eq('error message')
      end
    end
  end

  describe '#payload' do
    around do |example|
      ClimateControl.modify(HOST: 'www.hal.com', WEB_PORT: '80') do
        example.run
      end
    end

    let(:video) { double(:video, id: 100, videoable_id: 55, videoable_type: 'SceneCollection') }

    it 'builds params for API request' do
      expect_any_instance_of(OnvedeoVideoEncoder).to receive(:settings) { 'encoder_settings' }

      expected = {
        video: {
          reference: { type: video.videoable_type, id: video.videoable_id, video_id: video.id },
          vgl: 'vgl',
          priority: 'normal',
          stream_callback_url: 'http://www.hal.com/callbacks/100/stream',
          encoding_settings: 'encoder_settings',
          width: definition.width,
          height: definition.height,
        }
      }

      expect(subject.payload(video: video)).to eq(expected)
    end
  end
end
