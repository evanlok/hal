require 'rails_helper'

RSpec.describe DefinitionFactory do
  describe '.fetch' do
    subject { DefinitionFactory.fetch(content) }

    context 'for SceneCollection' do
      let(:content) { build(:scene_collection) }
      it { is_expected.to be_a(Engine::Definitions::SceneCollectionVideo) }
    end

    context 'for Scene' do
      let(:content) { build(:scene) }
      it { is_expected.to be_a(Engine::Definitions::ScenePreviewVideo) }
    end

    context 'for VideoContent' do
      let(:content) { build(:video_content) }
      it { is_expected.to be_a("Engine::Definitions::#{content.definition.video_type.name}::#{content.definition.class_name}".constantize) }
    end

    context 'for unknown type' do
      let(:content) { User.new }

      it 'raises exception' do
        expect { subject }.to raise_error(StandardError)
      end
    end
  end
end
