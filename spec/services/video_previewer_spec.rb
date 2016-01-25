require 'rails_helper'

RSpec.describe VideoPreviewer do
  let(:definition) { double(:definition, to_vgl: 'vgl') }
  let(:scene) { create(:scene) }
  let(:video_previewer) { VideoPreviewer.new(definition, scene) }

  describe '#create_video_preview' do
    it 'posts video to vidgenie API' do
      expected_params = {
        video: {
          vgl: 'vgl',
          priority: VideoPreviewer::DEFAULT_PRIORITY,
          stream_only: true,
          stream_callback_url: /\/callbacks\/\d+\/preview/
        }
      }

      expect_any_instance_of(VidgenieAPIClient).to receive(:post_video).with(expected_params)
      expect(video_previewer).to receive(:build_vgl) { 'vgl' }
      video_previewer.create_video_preview
    end

    it 'creates VideoPreview with reference' do
      allow_any_instance_of(VidgenieAPIClient).to receive(:post_video)
      expect { video_previewer.create_video_preview }.to change { VideoPreview.count }.by(1)
      expect(VideoPreview.last.previewable).to eq(scene)
    end

    context 'when errors are present' do
      it 'returns false' do
        video_previewer.errors << 'error'
        expect(video_previewer.create_video_preview).to be false
      end
    end
  end

  describe '#build_vgl' do
    it 'returns definition vgl' do
      expect(video_previewer.build_vgl).to eq('vgl')
    end

    context 'when vgl compilation fails' do
      it 'assigns message to errors array' do
        expect(definition).to receive(:to_vgl).and_raise(StandardError.new('error message'))
        video_previewer.build_vgl
        expect(video_previewer.errors).to eq(['error message'])
      end
    end
  end
end
