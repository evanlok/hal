require 'rails_helper'

RSpec.describe VideoCallbackNotifier do
  let(:video_content) { create(:video_content, callback_url: 'http://www.houztrendz.com/callback') }
  let!(:video) { create(:video, videoable: video_content) }
  let(:notifier) { VideoCallbackNotifier.new(video_content) }

  describe '#send_callback_notification' do
    it 'sends POST request to callback url' do
      stub = stub_request(:post, video_content.callback_url).with(body: notifier.payload.to_json, headers: { 'Content-Type' => 'application/json' })
      notifier.send_callback_notification
      expect(stub).to have_been_requested
    end

    context 'when callback_url is blank' do
      let(:video_content) { create(:video_content, callback_url: '') }

      it 'does nothing' do
        expect(notifier.send_callback_notification).to be_nil
      end
    end
  end
end
