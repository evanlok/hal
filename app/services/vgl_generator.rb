class VGLGenerator
  SKETCH_TEMPLATE = <<-EOS
class Engine::Definitions::<%= definition.class_name %> < Engine::Definitions::AbstractDefinition
  <%= definition.vgl_header -%>

  def content
    <%= definition.vgl_content %>
  end

  <%= definition.vgl_methods %>
end
  EOS

  attr_reader :video, :definition

  def initialize(video)
    @video = video
    @definition = video.definition
  end

  def definition_class
    @definition_class ||= begin
      evaluate_code
      "Engine::Definitions::#{definition.class_name}".constantize
    end
  end

  def generate_definition_code
    ERB.new(SKETCH_TEMPLATE, nil, '%<>-').result(binding)
  end

  def evaluate_code
    Object.class_eval generate_definition_code, Rails.root.to_s + "/app/models/engine/definitions/#{definition.class_name.underscore}", -1
  end

  def definition_instance
    @definition_instance ||= definition_class.new(@video)
  end

  def vgl
    @vgl ||= definition_instance.to_vgl
  end
end
