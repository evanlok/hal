require 'csv'

module Importers
  class CoreLogicLocationCSVImporter
    def initialize(file_path)
      @file_path = file_path
    end

    def import
      CSV.foreach(@file_path, headers: true).each_with_index do |row, i|
        if i % 8 != 3
          next
        else
          cl = CoreLogicLocation.where(zip_code: row[0]).first_or_initialize
          attributes = %w(tier_name metrics active_list_price_mean active_list_price_median active_listings_dom_mean active_listings_dom_median active_listings_inventory_count sold_inventory_count sold_list_price_mean sold_listings_dom_mean)
          # First column is the id
          row.fields.drop(1).each_with_index do |value, i|
            cl[attributes[i]] = value.try(:strip)
          end
          cl.save
        end
      end
    end
  end
end
