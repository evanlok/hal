require 'csv'

module Importers
  class CoreLogicLocationCSVImporter
    DEFINITION_NAME = 'CoreLogic'.freeze
    ATTRIBUTES = %w(
      zip_code
      tier_name
      new_listings_inventory_count
      new_listings_inventory_count_12m_change
      active_listings_inventory_count
      active_listings_inventory_count_1m_change
      sold_inventory_count
      sold_inventory_count_12m_change
      sold_inventory_count_1m_change
      sold_listings_dom_mean
      sold_listings_dom_mean_12m_change
      sold_list_price_mean
      sold_list_price_mean_12m_change
      sold_list_price_mean_1m_change
      active_list_price_mean
      active_list_price_median
      active_listings_dom_mean
      cumulative_active_dom_mean
    )

    def initialize(file_path)
      @file_path = file_path
      @definition = Definition.find_by!(name: DEFINITION_NAME)
    end

    def import
      current_date = nil

      CSV.foreach(@file_path, converters: :numeric) do |row|
        # Date row
        if row[0] =~ /Period Date:/
          month, day, year = row[0].split(':').last.strip.split('/').map(&:to_i)
          current_date = Date.new(year, month, day)
        end

        # Data row
        if row[0].to_s =~ /\A\d+\z/ && row.count == ATTRIBUTES.count && current_date
          zip_code = row[0]
          video_content = VideoContent.where(definition: @definition, uid: generate_uid(zip_code, current_date)).first_or_initialize
          data = {}
          parsed_row = row.map { |val| parse_number(val) }

          ATTRIBUTES.each_with_index do |attr, i|
            data[attr] = parsed_row[i]
          end

          video_content.data = data

          begin
            video_content.save!
          rescue ActiveRecord::RecordInvalid => e
            Honeybadger.notify(e, context: { date: current_date, zip_code: zip_code })
          ensure
            current_date = nil
          end
        end
      end
    end

    private

    def generate_uid(zip_code, date)
      "#{zip_code}-#{date}"
    end

    def parse_number(input)
      return input unless input.is_a?(String)

      case input
      when /\A-?[\d\.,]+[^%]\z/
        input.gsub(',', '').to_f
      when /\A\([\d\.,]+%?\)\z/
        input.gsub(/[\(\)]/, '').prepend('-')
      else
        input
      end
    end
  end
end
