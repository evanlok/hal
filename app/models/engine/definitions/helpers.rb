module Engine
  module Definitions
    module Helpers
      extend ActiveSupport::Concern

      def plural(key, count, options={})
        count = count.to_i if count.to_f % 1 == 0
        if count == 1
          I18n.t(key, count: options[:hide] ? nil : count).strip
        else
          I18n.t("#{key}_plural", count: options[:hide] ? nil : count).strip
        end
      end

      def watermark(duration=7, delay=1, options={})
        url = 'https://vejeo.s3.amazonaws.com/vidgenie/images/ov-logo-watermark.png'
        b.image(url, '100', '100', nil, nil, { align: 'bottom-right' }.merge(options))
        .animate('100', '100', duration: 1, opacity: 0..1)
        .animate('100', '100', duration: duration-2, opacity: 1)
        .animate('100', '100', duration: 1, opacity: 1..0).delay(delay)
      end
    end
  end
end
