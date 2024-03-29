class VideoGenerator
  attr_reader :definition, :content, :errors

  def initialize(definition)
    @definition = definition
    @content = definition.video_content
    @errors = []
  end

  def generate(priority: 'normal', callback_url: nil, stream_callback_url: nil)
    return false unless valid?
    resolutions = VideoResolutions.new(definition.width, definition.height).json
    video = content.videos.create(callback_url: callback_url, stream_callback_url: stream_callback_url, resolutions: resolutions)
    payload = payload(priority: priority, video: video)
    VidgenieAPIClient.new.post_video(payload)
    video
  end

  def payload(priority: 'normal', video:)
    attrs = {
      video: {
        reference: { type: video.videoable_type, id: video.videoable_id, video_id: video.id },
        vgl: build_vgl,
        priority: priority,
        stream_callback_url: Rails.application.routes.url_helpers.stream_callback_url(video_id: video.id, host: ENV['HOST'], port: ENV['WEB_PORT']),
        width: definition.width,
        height: definition.height
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
    rescue StandardError, SyntaxError => e
      errors << e.message
      errors << e.backtrace[0]

      Honeybadger.notify(
        error_class: definition.class.to_s,
        error_message: "#{definition.class.to_s}: #{e.message}",
        backtrace: e.backtrace,
        context: { type: content.class.to_s, id: content.id }
      )
    end
  end
end
