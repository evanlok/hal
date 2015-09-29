class VGLGenerator
  SKETCH_TEMPLATE = <<-EOS
module Engine
  module Definitions
    module <%= definition.video_type.name %>
      class <%= definition.class_name %> < AbstractDefinition
        <%= definition.vgl_header -%>

        def content
          <%= definition.vgl_content %>
        end

        <%= definition.vgl_methods %>
      end
    end
  end
end
EOS

  attr_reader :video_content, :definition

  def initialize(video_content)
    @video_content = video_content
    @definition = video_content.definition
  end

  def definition_class
    @definition_class ||= begin
      evaluate_code
      "Engine::Definitions::#{definition.video_type.name}::#{definition.class_name}".constantize
    end
  end

  def generate_definition_code
    ERB.new(SKETCH_TEMPLATE, nil, '%<>-').result(binding)
  end

  def evaluate_code
    Object.class_eval generate_definition_code, Rails.root.to_s + "/app/models/engine/definitions/#{definition.video_type.name.underscore}/#{definition.class_name.underscore}", -1
  end

  def definition_instance
    @definition_instance ||= definition_class.new(video_content)
  end

  def vgl
    @vgl ||= definition_instance.to_vgl
  end
end
