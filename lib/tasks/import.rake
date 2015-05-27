namespace :import do
  desc 'Import FindTheBest location records from a CSV file'
  task :find_the_best, [:file] => :environment do |t, args|
    fail 'You need to specify a file location' unless args.file

    Importers::FindTheBestLocationCSVImporter.new(args.file).import
  end
end
