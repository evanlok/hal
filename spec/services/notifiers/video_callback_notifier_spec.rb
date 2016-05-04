require 'rails_helper'

RSpec.describe Notifiers::VideoCallbackNotifier do
  let(:video) { create(:video) }
  let(:notifier) { Notifiers::VideoCallbackNotifier.new(video) }

  describe '#send_callback_notification' do
    it 'sends POST request to callback url' do
      expect(Notifiers::NotificationClient).to receive(:new).with(video.callback_url).and_call_original
      expect_any_instance_of(Notifiers::NotificationClient).to receive(:post).with(notifier.payload)
      notifier.send_callback_notification
    end

    context 'when callback_url is blank' do
      let(:video) { build(:video, callback_url: '') }

      it 'does nothing' do
        expect(notifier.send_callback_notification).to be_nil
      end
    end
  end
end
