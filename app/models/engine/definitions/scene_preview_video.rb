module Engine
  module Definitions
    class ScenePreviewVideo < AbstractDefinition
      attr_reader :scene_vgl, :scene_data

      alias :video_data :scene_data

      def initialize(scene_vgl, scene_data = {})
        @scene_vgl = scene_vgl
        @scene_data = Hashie::Mash.new(scene_data.present? ? scene_data : {})
      end

      def content
        b.stack do
          eval(scene_vgl)
        end
      end
    end
  end
end
