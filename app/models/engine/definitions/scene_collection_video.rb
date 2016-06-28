module Engine
  module Definitions
    class SceneCollectionVideo < AbstractDefinition
      alias_method :scene_collection, :video_content

      def content
        if video_data.user_audio.present?
          b.audio(video_data.user_audio, volume: -5, file: true)
          music_volume = -20
        else
          music_volume = -15
        end

        b.audio(video_data.music, volume: music_volume, file: true) if video_data.music.present?
        b.set_default_font(video_data.font) if video_data.font.present?

        scene_collection.scenes.each_with_index do |scene, idx|
          scene_content = scene_collection.video_data.scenes[idx]
          scene_data = scene_content.data
          Honeybadger.context(scene_id: scene.id, scene_content: scene_content)

          b.stack(background: scene.background) do
            bnd = binding
            bnd.local_variable_set(:global_color, hex_to_rgb_string(video_data.color))
            bnd.local_variable_set(:video_data, scene_data)
            eval(scene.vgl_content, bnd)
          end

          if scene_content.transition.present? && scene_content != scene_collection.video_data.scenes.last
            b.transition(scene_content.transition, 1)
          end
        end
      end

      private

      def hex_to_rgb_string(hex)
        return if hex.blank?
        color = Color::RGB.by_hex(hex)
        "#{color.red.to_i},#{color.green.to_i},#{color.blue.to_i}"
      end
    end
  end
end
