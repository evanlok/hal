class OnvedeoVideoEncoder
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def settings
    {
      reference_id: video.id,
      notifications: notifications,
      outputs: sd_outputs + hd_outputs
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

  def sd_outputs
    [
      video_output('low', "#{filename}_240.mp4", 428, 240),
      video_output('medium', "#{filename}.mp4", 640, 360, {
        thumbnails: {
          format: 'jpg',
          number: 1,
          size: '640x360',
          base_url: base_url,
          filename: 'thumb'
        }
      })
    ]
  end

  def hd_outputs
    [
      video_output('high', "#{filename}_720.mp4", 1280, 720, {
        thumbnails: {
          format: 'jpg',
          number: 1,
          size: '1280x720',
          base_url: base_url,
          filename: 'thumb_720'
        }
      })
    ]
  end

  def notifications
    [
      {
        url: Rails.application.routes.url_helpers.encoder_callback_url(host: ENV['HOST'], port: ENV['PORT'])
      }
    ]
  end
end
