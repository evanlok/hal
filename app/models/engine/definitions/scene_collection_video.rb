module Engine
  module Definitions
    class SceneCollectionVideo < AbstractDefinition
      alias_method :scene_collection, :video_content

      def content
        b.audio(video_data.music, volume: -15, file: true) if video_data.music.present?
        b.set_default_font(video_data.font) if video_data.font.present?

        scene_collection.scenes.each_with_index do |scene, idx|
          scene_content = scene_collection.video_data.scenes[idx]
          scene_data = scene_content.data
          Honeybadger.context(scene_id: scene.id, scene_content: scene_content)

          b.stack do
            bnd = binding
            bnd.local_variable_set(:video_data, scene_data)
            eval(scene.vgl_content, bnd)
          end

          if scene_content.transition.present? && scene_content != scene_collection.video_data.scenes.last
            b.transition(scene_content.transition, scene_content.transition_duration)
          end
        end
      end
    end
  end
end
