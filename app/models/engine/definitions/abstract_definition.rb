module Engine
  module Definitions
    class AbstractDefinition
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::NumberHelper
      include Engine::Definitions::StyleDSL
      include Engine::Definitions::Helpers

      attr_reader :video_content, :currency, :language_name, :asset_folder, :builder
      alias :b :builder
      delegate :video_data, to: :video_content

      def initialize(video_content, options={})
        options.reverse_merge!(branded: true, currency: 'usd', language: 'en', asset_folder: 'classic/black_v2')

        @video_content = video_content
        @currency       = options.delete(:currency)
        @language_name  = options.delete(:language)
        @asset_folder   = options.delete(:asset_folder)
      end

      # Attention!
      #
      # Write code to generate vidgenie engine ruby file
      #
      def builder
        Engine::VGL::Builder.new do |builder|
          if %w(zh-cn ko).include?(language_name)
            builder.set_default_font unicode_font
          else
            builder.set_default_font font_family
          end

          @builder = builder
          content
        end
      end

      def to_vgl
        builder.to_vgl
      end

      def content
        raise NotImplementedError.new('All subclasses of AbstractDefinition must override #content.')
      end

      # TODO: Remove once all ftb_location references are changed to video_data or VideoContent objects
      def ftb_location
        video_content.video_data
      end

      private

      def unicode_font
        'http://vejeo.s3.amazonaws.com/vidgenie/fonts/Arial_Unicode.ttf'
      end
    end
  end
end
