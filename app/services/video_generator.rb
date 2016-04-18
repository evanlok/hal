class VideoGenerator
  attr_reader :definition, :content, :errors

  def initialize(definition)
    @definition = definition
    @content = definition.video_content
    @errors = []
  end

  def generate(priority = 'normal')
    return false unless valid?
    video = content.videos.create
    payload = payload(priority: priority, video: video)
    VidgenieAPIClient.new.post_video(payload)
    video
  end

  def payload(priority: 'normal', video: video)
    attrs = {
      video: {
        reference: { type: video.videoable_type, id: video.videoable_id, video_id: video.id },
        vgl: build_vgl,
        priority: priority,
        stream_callback_url: Rails.application.routes.url_helpers.stream_callback_url(video_id: video.id, host: ENV['HOST'], port: ENV['WEB_PORT'])
      }
    }

    attrs[:video][:encoding_settings] = OnvedeoVideoEncoder.new(video).settings
    attrs
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
