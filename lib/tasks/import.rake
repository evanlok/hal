namespace :import do
=begin
  desc 'Import FindTheBest location records from a CSV file'
  task :find_the_best, [:file] => :environment do |t, args|
    fail 'You need to specify a file location' unless args.file

    Importers::FindTheBestLocationCSVImporter.new(args.file).import
  end
=end
  desc 'Import CoreLogic location records from a CSV file'
  task :core_logic, [:file] => :environment do |t, args|
    fail 'You need to specify a file location' unless args.file

    Importers::CoreLogicLocationCSVImporter.new(args.file).import
  end
end
