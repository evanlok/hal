module Notifiers
  class PreviewCallbackNotifier
    attr_reader :video_preview

    def initialize(video_preview)
      @video_preview = video_preview
    end

    def self.notify(video_preview)
      new(video_preview).send_callback_notification
    end

    def send_callback_notification
      return if video_preview.callback_url.blank?
      NotificationClient.new(video_preview.callback_url).post(payload)
    end

    def payload
      {
        id: video_preview.previewable_id,
        stream_url: video_preview.stream_url,
        preview: true
      }
    end
  end
end
