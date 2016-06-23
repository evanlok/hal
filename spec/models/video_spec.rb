require 'rails_helper'

RSpec.describe Video, type: :model do
  describe '#base_dir' do
    let(:video) { build_stubbed(:video) }

    it 'returns base dir for video storage' do
      expect(video.base_dir).to eq("videos/#{video.id}")
    end
  end

  describe '#path' do
    let(:video) { build_stubbed(:video) }

    before do
      allow(video).to receive(:base_dir) { 'base' }
    end

    it 'returns video path' do
      expect(video.path).to eq("base/#{video.filename}")
    end

    context 'with version arg' do
      it 'returns path with version appended' do
        expect(video.path(720)).to eq("base/#{video.filename.gsub('.mp4', '')}_720.mp4")
      end
    end
  end

  describe '#url' do
    let(:video) { build_stubbed(:video) }

    before do
      allow(video).to receive(:path) { 'videos/123/video.mp4' }
    end

    it 'joins CDN with path' do
      expect(video.url).to eq("#{ENV['CDN_URL']}/#{video.path}")
    end
  end
end
