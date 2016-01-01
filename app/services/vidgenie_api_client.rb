class VidgenieAPIClient
  attr_reader :vidgenie_server_url

  def initialize(vidgenie_server_url = ENV['VIDGENIE_SERVER_URL'])
    @vidgenie_server_url = vidgenie_server_url
  end

  def post_video(payload)
    client.post('/videos', payload.to_json)
  end

  def client
    Faraday.new(url: vidgenie_server_url, headers: { 'Content-Type' => 'application/json' }) do |f|
      f.response :logger, Rails.logger, bodies: true
      f.response :raise_error
      f.adapter :typhoeus
    end
  end
end
