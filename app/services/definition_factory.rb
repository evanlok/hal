class DefinitionFactory
  def self.fetch(content)
    case content
    when SceneCollection
      Engine::Definitions::SceneCollectionVideo.new(content)
    when Scene
      Engine::Definitions::ScenePreviewVideo.new(content)
    when VideoContent
      DefinitionBuilder.new(content).definition_instance
    else
      raise "Cannot find definition for object: #{content.class}"
    end
  end
end
