require 'rails_helper'

RSpec.describe SceneAttribute do
  describe '#cast_display_config_values' do
    let(:scene_attribute) do
      build(:scene_attribute, display_config: { blank: '', int: '1234', float: '345.67', string: 'string' })
    end

    subject { scene_attribute.display_config.with_indifferent_access }
    before { scene_attribute.send(:cast_display_config_values) }

    it 'removes blank values' do
      expect(subject).to_not include(:blank)
    end

    it 'casts strings into integers' do
      expect(subject[:int]).to eq(1234)
    end

    it 'casts strings into floats' do
      expect(subject[:float]).to eq(345.67)
    end

    it 'leaves string values unchanged' do
      expect(subject[:string]).to eq('string')
    end
  end
end
