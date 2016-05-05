require 'rails_helper'

RSpec.describe Engine::Definitions::SceneCollectionVideo do
  let(:scene) { create(:scene, vgl_content: 'b.text(scene_data.agent_name); b.rect(0, 0, 10, 10, color: global_color)') }

  let(:data) do
    {
      font: 'http://vejeo.s3.amazonaws.com/vidgenie/fonts/lato/Lato-Bold.ttf',
      music: 'https://vejeo.s3.amazonaws.com/vidgenie/audio/music/soothing/soothing-8.mp3',
      color: '#cccccc',
      callback_url: Faker::Internet.url,
      scenes: [
        {
          scene_id: scene.id,
          data: {
            agent_name: 'John Doe'
          },
          transition: 'SlideUp',
          transition_duration: 2.5
        },
        {
          scene_id: create(:scene).id,
          data: {
            city: 'San Francisco'
          },
          transition: 'SlideDown',
          transition_duration: 2.5
        }
      ]
    }
  end

  let(:scene_collection) { create(:scene_collection, data: data) }
  let(:definition) { described_class.new(scene_collection) }

  describe '#to_vgl' do
    it 'evaluates vgl content for each scene' do
      expect(definition.to_vgl).to be_a(String)
      expect(definition.to_vgl).to include('John Doe')
    end

    it 'inserts font vgl' do
      expect(definition.to_vgl).to match(/set_default_font.+#{data[:font]}/)
    end

    it 'inserts music vgl' do
      expect(definition.to_vgl).to match(/audio.+#{data[:music]}/)
    end

    it 'inserts scene transitions' do
      expect(definition.to_vgl).to match(/transition\("#{data[:scenes][0][:transition]}",1\)/)
    end

    it 'converts color to RGB' do
      expect(definition.to_vgl).to match(/:color=>"204,204,204"/)
    end
  end
end
