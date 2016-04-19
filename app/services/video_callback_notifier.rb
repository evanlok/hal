class VideoCallbackNotifier
  delegate :url_helpers, to: 'Rails.application.routes'

  attr_reader :video

  def initialize(video)
    @video = video
  end

  def self.notify(video)
    new(video).send_callback_notification
  end

  def send_callback_notification
    return if video.videoable.callback_url.blank?

    conn = Faraday.new(url: video.videoable.callback_url, headers: { 'Content-Type' => 'application/json' }) do |f|
      f.request :retry
      f.response :logger, Rails.logger, bodies: true
      f.response :raise_error
      f.adapter :typhoeus
    end

    conn.post('', payload.to_json)
  end

  def payload
    {
      id: video.videoable.id,
      thumbnail_url: video.thumbnail_url,
      duration: video.duration,
      embed_url: url_helpers.video_url(video, host: ENV['HOST'], port: ENV['WEB_PORT']),
      videos: [
        {
          url: video.url,
          width: 640,
          height: 360
        },
        {
          url: video.url(720),
          width: 1280,
          height: 720
        }
      ]
    }
  end
end
