class VidgenieClient
  attr_reader :vgl_generator, :encoder, :priority, :reference

  def initialize(vgl_generator, encoder, priority, reference = {})
    @vgl_generator = vgl_generator
    @encoder = encoder
    @priority = priority
    @reference = reference
  end

  def self.post_video(video, priority)
    vgl_generator = VGLGenerator.new(video)
    encoder = OnvedeoVideoEncoder.new(video)
    new(vgl_generator, encoder, priority, { type: video.videoable_type, id: video.videoable_id }).post_to_server
  end

  def post_to_server
    conn = Faraday.new(url: ENV['VIDGENIE_SERVER_URL'], headers: { 'Content-Type' => 'application/json' }) do |f|
      f.response :logger, Rails.logger, bodies: true
      f.response :raise_error
      f.adapter :typhoeus
    end

    conn.post('/videos', payload.to_json)
  end

  def payload
    {
      reference: reference,
      vgl: vgl_generator.vgl,
      priority: priority,
      encoding_settings: encoder.settings
    }
  end
end
