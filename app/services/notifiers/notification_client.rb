module Notifiers
  class NotificationClient
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def post(payload)
      client.post('', payload.to_json)
    end

    private

    def client
      Faraday.new(url: url, headers: { 'Content-Type' => 'application/json' }) do |f|
        f.request :retry
        f.response :logger, Rails.logger, bodies: true
        f.response :raise_error
        f.adapter :typhoeus
      end
    end
  end
end
