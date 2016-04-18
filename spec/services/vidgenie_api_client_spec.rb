require 'rails_helper'

RSpec.describe VidgenieAPIClient do
  around do |example|
    ClimateControl.modify(VIDGENIE_SERVER_URL: 'http://www.vidgenie.com') do
      example.run
    end
  end

  describe '#post_video' do
    it 'sends POST to videos endpoint' do
      stub = stub_request(:post, "#{ENV['VIDGENIE_SERVER_URL']}/videos").with(body: { data: 123 })
      subject.post_video(data: 123)
      expect(stub).to have_been_requested
    end
  end
end
