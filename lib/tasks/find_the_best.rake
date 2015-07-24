namespace :find_the_best do
  desc 'Generate all videos for FindTheBestLocation records'
  task :generate_all, [:definition_name] => :environment do |t, args|
    raise 'definition_name must be specified' unless args.definition_name
    definition = Definition.find_by(name: args.definition_name)

    FindTheBestLocation.includes(:video).find_each do |ftb|
      begin
        VideoGenerator.new(ftb, definition).generate
      rescue => e
        Honeybadger.notify(e, context: {find_the_best_location_id: ftb.id})
      end
    end
  end
end
