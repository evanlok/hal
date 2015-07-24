module Engine
  module Definitions
    module StyleDSL
      extend ActiveSupport::Concern

      included do
        class_attribute :_font_family
        class_attribute :_colors
      end

      def font_family
        self.class._font_family
      end

      def colors
        self.class._colors
      end

      def asset_url(filename)
        "http://vejeo.s3.amazonaws.com/vidgenie/images/#{asset_folder}/#{filename}"
      end

      def icon_url(filename)
        "https://vejeo.s3.amazonaws.com/vidgenie/images/icons/#{filename}"
      end

      module ClassMethods
        def font_family(string)
          self._font_family = string
        end

        def colors(hash)
          self._colors = hash
        end
      end
    end
  end
end
