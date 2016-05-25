class OnvedeoVideoEncoder
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def settings
    {
      reference_id: video.id,
      notifications: notifications,
      outputs: outputs
    }
  end

  def video_default_settings
    {
      base_url: base_url,
      public: true,
      video_codec: 'libx264',
      format: 'mp4',
      x264_preset: 'superfast'
    }
  end

  def base_url
    @base_url ||= "s3://#{ENV['S3_BUCKET']}/#{video.base_dir}"
  end

  def filename
    @filename ||= SecureRandom.uuid
  end

  def video_output(label, filename, width, height, options={})
    output = video_default_settings
    output.merge!({ label: label, filename: filename, resolution: "#{width}x#{height}" })
    output.merge!(options)
  end

  def outputs
    raise "Video #{video.id} has no resolutions assigned" if video.resolutions.blank?

    video.resolutions.map do |name, (width, height)|
      video_output(name, "#{filename}_#{height}.mp4", width, height, {
        thumbnail: {
          format: 'jpg',
          number: 1,
          size: "#{width}x#{height}",
          base_url: base_url,
          filename: "thumb_#{height}"
        }
      })
    end
  end

  def notifications
    [
      {
        url: Rails.application.routes.url_helpers.encoder_callback_url(video_id: video.id, host: ENV['HOST'], port: ENV['WEB_PORT'])
      }
    ]
  end
end
