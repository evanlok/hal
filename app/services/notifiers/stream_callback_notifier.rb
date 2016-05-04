module Notifiers
  class StreamCallbackNotifier
    attr_reader :video

    def initialize(video)
      @video = video
    end

    def self.notify(video)
      new(video).send_callback_notification
    end

    def send_callback_notification
      return if video.stream_callback_url.blank?
      NotificationClient.new(video.stream_callback_url).post(payload)
    end

    def payload
      {
        id: video.videoable_id,
        stream_url: video.stream_url,
        preview: false
      }
    end
  end
end
