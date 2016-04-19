require 'rails_helper'

RSpec.shared_examples_for Previewable do
  describe '#preview' do
    let(:definition) { double(:definition) }
    let(:video_preview) { build(:video_preview) }
    subject { described_class.new }

    it 'triggers video preview and returns video preview record' do
      expect(DefinitionFactory).to receive(:fetch).with(subject) { definition }
      expect_any_instance_of(VideoPreviewer).to receive(:create_video_preview) { video_preview }
      expect(subject.preview).to eq(video_preview)
    end

    context 'with a definition arg' do
      it 'uses provided definition' do
        expect(DefinitionFactory).to_not receive(:fetch)
        expect_any_instance_of(VideoPreviewer).to receive(:create_video_preview) { video_preview }
        subject.preview(definition)
      end
    end

    context 'when previewer has errors' do
      let(:video_previewer) { double(:video_previewer, create_video_preview: false, errors: ['error message']) }

      it 'assigns errors to model' do
        allow(DefinitionFactory).to receive(:fetch)
        expect(VideoPreviewer).to receive(:new) { video_previewer }
        expect(subject.preview).to be false
        expect(subject.errors[:base]).to eq(['error message'])
      end
    end
  end
end

RSpec.describe SceneCollection do
  it_behaves_like Previewable
end

RSpec.describe Scene do
  it_behaves_like Previewable
end
