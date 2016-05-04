require 'rails_helper'

RSpec.describe DefinitionBuilder do
  let(:definition) { build(:definition) }
  let(:video_content) { build(:video_content, definition: definition) }
  subject { DefinitionBuilder.new(video_content) }

  describe '#definition_class' do
    it 'returns class object of generated definition' do
      expect(subject.definition_class).to eq("Engine::Definitions::#{definition.video_type.name}::#{definition.class_name}".constantize)
    end
  end

  describe '#generate_definition_code' do
    it 'evaluates ERB template and returns a string' do
      result = subject.generate_definition_code
      expect(result).to be_a(String)
      expect(result).to match(/#{definition.class_name} < AbstractDefinition/)
      expect(result).to match(/#{definition.vgl_header}/)
      expect(result).to match(/def content\n\s*#{definition.vgl_content}/)
    end
  end

  describe '#evaulate_code' do
    it 'runs eval on generated definition' do
      expect(subject).to receive(:generate_definition_code) { 'code' }
      expect(Object).to receive(:class_eval).with('code', Rails.root.to_s + "/app/models/engine/definitions/#{definition.video_type.name.underscore}/#{definition.class_name.underscore}", -1)
      subject.evaluate_code
    end
  end

  describe '#definition_instance' do
    it 'returns a new instance of the generated definition' do
      expect(subject.definition_instance).to be_an_instance_of(subject.definition_class)
    end
  end
end
