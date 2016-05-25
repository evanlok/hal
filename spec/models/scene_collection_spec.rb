require 'rails_helper'

RSpec.describe SceneCollection do
  let(:location_scene) { create(:scene) }
  let(:agent_scene) { create(:scene) }

  let(:data) do
    {
      font: 'http://vejeo.s3.amazonaws.com/vidgenie/fonts/lato/Lato-Bold.ttf',
      music: 'https://vejeo.s3.amazonaws.com/vidgenie/audio/music/soothing/soothing-8.mp3',
      color: '#cccccc',
      callback_url: Faker::Internet.url,
      scenes: [
        {
          scene_id: agent_scene.id,
          data: {
            name: 'John Doe',
          },
          transition: 'SlideUp',
          transition_duration: 2.5
        },
        {
          scene_id: location_scene.id,
          data: {
            city: 'San Francisco',
            state: 'Caifornia'
          },
          transition: 'SlideUp',
          transition_duration: 2.5
        }
      ]
    }
  end

  let(:scene_collection) { build(:scene_collection, data: data) }

  describe '#scenes' do
    it 'returns scenes in order' do
      expect(scene_collection.scenes).to eq([agent_scene, location_scene])
    end
  end

  describe '#callback_url' do
    it 'returns callback_url from data' do
      expect(scene_collection.callback_url).to eq(data[:callback_url])
    end
  end

  describe '#video_data' do
    it 'returns a Hashie::Mash of data' do
      expect(scene_collection.video_data).to be_a(Hashie::Mash)
      expect(scene_collection.video_data).to be_present
    end
  end

  describe 'validations' do
    describe '#scenes_have_same_dimensions?' do
      it 'is valid when scenes contain same resolutions' do
        expect(scene_collection).to be_valid
      end

      context 'when scenes have different resolutions' do
        let(:location_scene) { create(:scene, width: 600, height: 600) }

        it 'is invalid when scenes have different widths or heights' do
          expect(scene_collection).to_not be_valid
        end
      end
    end
  end
end
