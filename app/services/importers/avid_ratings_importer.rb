module Importers
  class AvidRatingsImporter
    DEFINITION_NAME = 'AvidRatings'.freeze

    def initialize
      @definition = Definition.find_by!(name: DEFINITION_NAME)
    end

    def import_and_generate
      import

      VideoContent.where(definition: @definition).find_each do |video_content|
        begin
          video_content.generate
        rescue => e
          Honeybadger.notify(e, context: { video_content_id: video_content.id })
        end
      end
    end

    def import
      fetch_reports.each do |report|
        begin
          video_content = VideoContent.where(definition: @definition, uid: report['id']).first_or_initialize
          video_content.callback_url = "#{ENV['AVID_RATINGS_SERVER_URL']}/v1.0/arsql/onvedeo/videoreports/#{report['id']}"
          video_content.data = report
          video_content.save!
        rescue => e
          Honeybadger.notify(e)
        end
      end
    end

    def fetch_reports
      client.get('/v1.0/arsql/onvedeo/feed', {}, {Authorization: "bearer #{fetch_jwt}"}).body.dig('results', 'reports')
    end

    def fetch_jwt
      @jwt_token ||= begin
        params = {
          username: ENV['AVID_RATINGS_USERNAME'],
          password: ENV['AVID_RATINGS_PASSWORD']
        }

        response = client.post('auth', params).body
        response['token']
      end
    end

    def client
      @client ||= Faraday.new(url: ENV['AVID_RATINGS_SERVER_URL']) do |f|
        f.request :json
        f.request :retry
        f.response :logger, Rails.logger
        f.response :raise_error
        f.response :json
        f.adapter Faraday.default_adapter
      end
    end
  end
end
