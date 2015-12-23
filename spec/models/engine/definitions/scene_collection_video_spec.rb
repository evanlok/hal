require 'rails_helper'

RSpec.describe Engine::Definitions::SceneCollectionVideo do
  let(:scene_collection) { create(:scene_collection) }
  let(:scene) { create(:scene, vgl_content: 'b.text(scene_data.agent_name)') }
  let!(:scene_content) { create(:scene_content, scene: scene, scene_collection: scene_collection, data: { agent_name: 'Agent Name' }) }
  let(:definition) { described_class.new(scene_collection) }

  describe '#to_vgl' do
    it 'evaluates vgl content for each scene' do
      expect(definition.to_vgl).to be_a(String)
      expect(definition.to_vgl).to include('Agent Name')
    end
  end
end
