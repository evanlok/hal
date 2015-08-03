require 'rails_helper'

RSpec.describe VidgenieClient do
  let(:encoder) { double(:encoder, settings: 'settings') }
  let(:vgl_generator) { double(:vgl_generator, vgl: 'vgl') }
  let(:priority) { 'normal' }
  let(:reference) { 'reference' }
  let(:vidgenie_client) { VidgenieClient.new(vgl_generator, encoder, priority, reference) }
  let(:vidgenie_server_url) { 'http://www.vidgenie.com' }

  around do |example|
    ClimateControl.modify VIDGENIE_SERVER_URL: vidgenie_server_url do
      example.run
    end
  end

  describe '#post_to_server' do
    it 'sends request to vidgenie server url' do
      stub_request(:post, "#{vidgenie_server_url}/videos").with(:headers => { 'Content-Type' => 'application/json' })
      vidgenie_client.post_to_server
      expect(a_request(:post, "#{vidgenie_server_url}/videos")).to have_been_made
    end
  end

  describe '#payload' do
    it 'returns hash to send to vidgenie server' do
      expected = {
        video: {
          reference: reference,
          vgl: vgl_generator.vgl,
          priority: priority,
          encoding_settings: encoder.settings
        }
      }

      expect(vidgenie_client.payload).to eq(expected)
    end
  end
end
