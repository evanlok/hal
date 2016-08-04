require 'rails_helper'

RSpec.describe VideoPreviewer do
  let(:definition) { double(:definition, to_vgl: 'vgl', width: 1280, height: 720) }
  let(:scene) { create(:scene) }
  let(:video_previewer) { VideoPreviewer.new(definition) }

  describe '#create_video_preview' do
    it 'posts video to vidgenie API' do
      expected_params = {
        video: {
          vgl: 'vgl',
          priority: VideoPreviewer::DEFAULT_PRIORITY,
          stream_only: true,
          stream_callback_url: /\/callbacks\/\d+\/preview/,
          width: 1280,
          height: 720
        }
      }

      expect_any_instance_of(VidgenieAPIClient).to receive(:post_video).with(expected_params)
      video_previewer.create_video_preview
    end

    it 'creates VideoPreview with reference' do
      allow_any_instance_of(VidgenieAPIClient).to receive(:post_video)
      expect { video_previewer.create_video_preview(reference: scene) }.to change { VideoPreview.count }.by(1)
      expect(VideoPreview.last.previewable).to eq(scene)
    end

    it 'creates VideoPreview with callback_url' do
      allow_any_instance_of(VidgenieAPIClient).to receive(:post_video)
      expect { video_previewer.create_video_preview(callback_url: 'callback') }.to change { VideoPreview.count }.by(1)
      expect(VideoPreview.last.callback_url).to eq('callback')
    end

    context 'when invalid' do
      it 'returns false' do
        expect(video_previewer).to receive(:valid?) { false }
        expect(video_previewer.create_video_preview).to be false
      end
    end
  end

  describe '#valid?' do
    it 'returns true when vgl is valid' do
      expect(video_previewer.valid?).to be true
    end

    context 'when vgl has build errors' do
      it 'returns false and sets errors' do
        expect(definition).to receive(:to_vgl).and_raise(StandardError, 'error message')
        expect(video_previewer.valid?).to be false
        expect(video_previewer.errors.count).to eq(2)
        expect(video_previewer.errors[0]).to eq('error message')
      end
    end
  end
end
