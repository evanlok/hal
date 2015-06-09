require 'rails_helper'

RSpec.describe Video, type: :model do
  describe '#base_dir' do
    let(:video) { build_stubbed(:video) }

    it 'returns base dir for video storage' do
      expect(video.base_dir).to eq("videos/#{video.id}")
    end
  end

  describe '#url' do
    let(:video) { build_stubbed(:video) }

    before do
      allow(video).to receive(:base_dir) { 'base' }
    end

    it 'returns video url' do
      expect(video.url).to eq("#{ENV['CDN_URL']}/base/#{video.filename}")
    end

    context 'with version arg' do
      it 'returns url with version appended' do
        expect(video.url(720)).to eq("#{ENV['CDN_URL']}/base/#{video.filename.gsub('.mp4', '')}_720.mp4")
      end
    end
  end
end
