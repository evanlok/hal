module Engine
  module Definitions
    class ScenePreviewVideo < AbstractDefinition
      attr_reader :scene_vgl, :scene_data

      alias :video_data :scene_data

      def initialize(scene_vgl, scene_data = {}, width: nil, height: nil, background: nil)
        @scene_vgl = scene_vgl
        @scene_data = Hashie::Mash.new(scene_data.present? ? scene_data : {})
        @width = width
        @height = height
      end

      def content
        b.stack(background: background) do
          eval(scene_vgl)
        end
      end

      def width
        @width || DEFAULT_WIDTH
      end

      def height
        @height || DEFAULT_HEIGHT
      end
    end
  end
end
