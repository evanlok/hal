require 'csv'

namespace :import do
  desc 'Import FindTheBest location records from a CSV file'
  task :find_the_best, [:file] => :environment do |t, args|
    fail 'You need to specify a file location' unless args.file

    CSV.foreach(args.file, headers: true) do |row|
      ftb = FindTheBestLocation.where(ftb_id: row[0]).first_or_initialize
      attributes = %w(sale_price_intro county sale_price_verb sale_price_change sale_price_end expected_intro expected_change expected_months list_price_intro list_price_change list_price_end market_text)

      # First column is the id
      row.fields.drop(1).each_with_index do |value, i|
        ftb[attributes[i]] = value.try(:strip)
      end

      ftb.save
    end
  end
end
