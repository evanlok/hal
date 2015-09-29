class VidgenieClient
  attr_reader :vgl_generator, :encoder, :priority, :reference

  def initialize(vgl_generator, encoder, priority, reference = {})
    @vgl_generator = vgl_generator
    @encoder = encoder
    @priority = priority
    @reference = reference
    fail ArgumentError, 'Missing video_id in reference' if reference[:video_id].blank?
  end

  def post_to_server(stream_only: false)
    conn = Faraday.new(url: ENV['VIDGENIE_SERVER_URL'], headers: { 'Content-Type' => 'application/json' }) do |f|
      f.response :logger, Rails.logger, bodies: true
      f.response :raise_error
      f.adapter :typhoeus
    end

    conn.post('/videos', payload(stream_only).to_json)
  end

  private

  def payload(stream_only)
    attrs = {
      video: {
        reference: reference,
        vgl: vgl_generator.vgl,
        priority: priority,
        stream_callback_url: Rails.application.routes.url_helpers.stream_callback_url(video_id: reference[:video_id], host: ENV['HOST'], port: ENV['WEB_PORT'])
      }
    }

    if stream_only
      attrs[:video][:stream_only] = true
    else
      attrs[:video][:encoding_settings] = encoder.settings
    end

    attrs
  end
end
