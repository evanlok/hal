class VideoPreviewer
  DEFAULT_PRIORITY = 'high'.freeze

  attr_reader :definition, :reference, :errors

  def initialize(definition, reference = nil)
    @definition = definition
    @reference = reference
    @errors = []
  end

  def create_video_preview
    return false unless valid?

    video_preview = VideoPreview.create(previewable: reference)
    params = {
      video: {
        vgl: build_vgl,
        priority: DEFAULT_PRIORITY,
        stream_only: true,
        stream_callback_url: Rails.application.routes.url_helpers.preview_callback_url(video_id: video_preview.id, host: ENV['HOST'], port: ENV['WEB_PORT'])
      }
    }

    VidgenieAPIClient.new.post_video(params)
    video_preview
  end

  def valid?
    build_vgl && errors.empty?
  end

  private

  def build_vgl
    begin
      @vgl ||= definition.to_vgl
    rescue => e
      errors << e.message
    end
  end
end
