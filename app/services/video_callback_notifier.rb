class VideoCallbackNotifier
  delegate :url_helpers, to: 'Rails.application.routes'

  attr_reader :video_content

  def initialize(video_content)
    @video_content = video_content
  end

  def self.notify(video_content)
    new(video_content).send_callback_notification
  end

  def send_callback_notification
    return if video_content.callback_url.blank?

    conn = Faraday.new(url: video_content.callback_url, headers: { 'Content-Type' => 'application/json' }) do |f|
      f.request :retry
      f.response :logger, Rails.logger, bodies: true
      f.response :raise_error
      f.adapter :typhoeus
    end

    conn.post('', payload.to_json)
  end

  def payload
    {
      id: video_content.id,
      uid: video_content.uid,
      definition: video_content.definition.class_name,
      video_type: video_content.definition.video_type.name,
      thumbnail_url: video_content.video.thumbnail_url,
      duration: video_content.video.duration,
      embed_url: url_helpers.video_url(video_content.video, host: ENV['HOST'], port: ENV['WEB_PORT']),
      video_url_360: video_content.video.url,
      video_url_720: video_content.video.url(720)
    }
  end
end
