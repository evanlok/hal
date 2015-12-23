module Engine
  module Definitions
    class SceneCollectionVideo < AbstractDefinition
      alias_method :scene_collection, :video_content

      def content
        scene_contents.each do |scene_content|
          b.stack do
            scene_content.scene_data.tap do |scene_data|
              Honeybadger.context(scene_id: scene_content.scene.id, scene_content_id: scene_content.id, scene_data: scene_data)
              eval(scene_content.scene.vgl_content)
            end
          end

          if scene_content.transition.present? && !scene_content.last?
            b.transition(scene_content.transition, scene_content.transition_duration)
          end
        end
      end

      def scene_contents
        scene_collection.scene_contents.by_position.includes(:scene)
      end
    end
  end
end
