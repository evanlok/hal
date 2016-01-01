class VideoPreviewer
  DEFAULT_PRIORITY = 'high'.freeze

  attr_reader :vgl, :reference

  def initialize(vgl, reference = nil)
    @vgl = vgl
    @reference = reference
  end

  def create_video_preview
    video_preview = VideoPreview.create(previewable: reference)
    params = {
      video: {
        vgl: vgl,
        priority: DEFAULT_PRIORITY,
        stream_only: true,
        stream_callback_url: Rails.application.routes.url_helpers.preview_callback_url(video_id: video_preview.id, host: ENV['HOST'], port: ENV['WEB_PORT'])
      }
    }

    VidgenieAPIClient.new.post_video(params)
    video_preview
  end
end
