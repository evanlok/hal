require 'rails_helper'

RSpec.describe VidgenieClient do
  let(:encoder) { double(:encoder, settings: 'settings') }
  let(:vgl_generator) { double(:vgl_generator, vgl: 'vgl') }
  let(:priority) { 'normal' }
  let(:reference) { { video_id: 100 } }
  let(:vidgenie_client) { VidgenieClient.new(vgl_generator, encoder, priority, reference) }
  let(:vidgenie_server_url) { 'http://www.vidgenie.com' }

  around do |example|
    ClimateControl.modify VIDGENIE_SERVER_URL: vidgenie_server_url do
      example.run
    end
  end

  describe '#post_to_server' do
    let(:default_params) do
      {
        video: {
          reference: reference,
          vgl: vgl_generator.vgl,
          priority: priority,
          stream_callback_url: Rails.application.routes.url_helpers.stream_callback_url(video_id: reference[:video_id], host: ENV['HOST'], port: ENV['WEB_PORT'])
        }
      }
    end

    before do
      stub_request(:post, "#{vidgenie_server_url}/videos").with(:headers => { 'Content-Type' => 'application/json' })
    end

    it 'sends request to vidgenie server url' do
      expected_params = default_params.deep_merge(video: {encoding_settings: encoder.settings})
      vidgenie_client.post_to_server
      expect(a_request(:post, "#{vidgenie_server_url}/videos").with(body: expected_params.to_json)).to have_been_made
    end

    context 'when stream_only is true' do
      it 'sends request to vidgenie server url with stream_only parameter' do
        expected_params = default_params.deep_merge(video: {stream_only: true})
        vidgenie_client.post_to_server(stream_only: true)
        expect(a_request(:post, "#{vidgenie_server_url}/videos").with(body: expected_params.to_json)).to have_been_made
      end
    end
  end
end
