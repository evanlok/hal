module Notifiers
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
      return if video.callback_url.blank?
      NotificationClient.new(video.callback_url).post(payload)
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
end
