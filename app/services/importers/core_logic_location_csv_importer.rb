require 'csv'

module Importers
  class CoreLogicLocationCSVImporter
    def initialize(file_path)
      @file_path = file_path
    end

    def import
      CSV.foreach(@file_path).each_with_index do |row, i|
        if row[0] =~ /Period Date:/
         date =  row[0].split(':').last.split(/ /).last.split('/')
         newdate = "#{date[2]}-#{date[0]}-#{date[1]}"
         @cl = CoreLogicLocation.where(period_date: newdate).first_or_initialize
        end
        next unless row[1] && row[1] != "Tier Name"
        attributes = %w(zip_code tier_name metrics active_list_price_mean active_list_price_median active_listings_dom_mean active_listings_dom_median active_listings_inventory_count sold_inventory_count sold_list_price_mean sold_listings_dom_mean)
       
        # First column is the id
        row.each_with_index do |value, i|
          if (i == 3 || i == 4 || i == 9)
            @cl[attributes[i]] = value.gsub(/,/,'')
          else
            @cl[attributes[i]] = value.try(:strip)
          end
        end
       @cl.save
      end
    end
  end
end

