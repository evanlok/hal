require 'rails_helper'

RSpec.describe VideoPreviewer do
  let(:scene) { create(:scene) }
  let(:video_previewer) { VideoPreviewer.new('vgl', scene) }

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
      video_previewer.create_video_preview
    end

    it 'creates VideoPreview with reference' do
      allow_any_instance_of(VidgenieAPIClient).to receive(:post_video)
      expect { video_previewer.create_video_preview }.to change { VideoPreview.count }.by(1)
      expect(VideoPreview.last.previewable).to eq(scene)
    end
  end
end
