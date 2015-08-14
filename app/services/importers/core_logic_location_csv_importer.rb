require 'csv'

module Importers
  class CoreLogicLocationCSVImporter
    def initialize(file_path)
      @file_path = file_path
    end

    def import
      CSV.foreach(@file_path, headers: true) do |row|
        cl = CoreLocationLocation.where(zip_code: row[0]).first_or_initialize
        attributes = %w(sale_price_intro county sale_price_verb sale_price_change sale_price_end expected_intro expected_change expected_months list_price_intro list_price_change list_price_end market_text)

        # First column is the id
        row.fields.drop(1).each_with_index do |value, i|
          cl[attributes[i]] = value.try(:strip)
        end

        cl.save
      end
    end
  end
end
