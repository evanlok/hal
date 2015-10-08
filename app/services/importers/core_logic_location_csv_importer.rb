require 'csv'

module Importers
  class CoreLogicLocationCSVImporter
    DEFINITION_NAME = 'CoreLogic'.freeze
    ATTRIBUTES = %w(
      county_name
      state
      cbsa_name
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
    ).freeze

    SHARED_ATTRIBUTES = ATTRIBUTES.first(5).freeze

    def initialize(file_path)
      @file_path = file_path
      @definition = Definition.find_by!(name: DEFINITION_NAME)
    end

    def import
      current_date = nil
      data_by_zip_code = Hash.new { |h, k| h[k] = HashWithIndifferentAccess.new(stats: []) }

      CSV.foreach(@file_path, converters: :numeric) do |row|
        # Date row
        if row[0] =~ /Period Date:/
          month, day, year = row[0].split(':').last.strip.split('/').map(&:to_i)
          current_date = Date.new(year, month, day)
        # Data row
        elsif row[3].to_s =~ /\A\d+\z/ && current_date
          zip_code = row[3]
          data = { date: current_date }
          parsed_row = row.map { |val| parse_number(val) }

          ATTRIBUTES.each_with_index do |attr, i|
            data[attr] = parsed_row[i]
          end

          shared_data = data.slice(*SHARED_ATTRIBUTES)
          stats_data = data.except(*SHARED_ATTRIBUTES)

          # Only keep the 2 most recent data rows per zip code
          data_by_zip_code[zip_code].merge!(shared_data)
          data_by_zip_code[zip_code][:stats].pop if data_by_zip_code[zip_code][:stats].length == 2
          data_by_zip_code[zip_code][:stats] << stats_data
        end
      end

      begin
        data_by_zip_code.each do |zip_code, data|
          video_content = VideoContent.where(definition: @definition, uid: zip_code).first_or_initialize
          data[:stats].sort_by! { |s| s['date'] }
          video_content.data = data
          video_content.save!
        end
      rescue ActiveRecord::RecordInvalid => e
        Honeybadger.notify(e, context: { zip_code: zip_code })
      end
    end

    private

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
