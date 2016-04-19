require 'rails_helper'

RSpec.shared_examples_for Generatable do
  describe '#generate' do
    let(:definition) { double(:definition, video_content: 'content') }
    let(:video) { build(:video) }
    subject { described_class.new }

    before do
      expect(DefinitionFactory).to receive(:fetch).with(subject) { definition }
    end

    it 'triggers video generation and returns video record' do
      expect_any_instance_of(VideoGenerator).to receive(:generate) { video }
      expect(subject.generate).to eq(video)
    end

    context 'when generator has errors' do
      let(:video_generator) { double(:video_generator, generate: false, errors: ['error message']) }

      it 'assigns errors to model' do
        expect(VideoGenerator).to receive(:new) { video_generator }
        expect(subject.generate).to be false
        expect(subject.errors[:base]).to eq(['error message'])
      end
    end
  end
end

RSpec.describe SceneCollection do
  it_behaves_like Generatable
end

RSpec.describe VideoContent do
  it_behaves_like Generatable
end
