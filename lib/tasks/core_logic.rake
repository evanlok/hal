namespace :core_logic do
  desc 'Generate all videos for CoreLogic records'
  task :generate_all, [:definition_name] => :environment do |t, args|
    raise 'definition_name must be specified' unless args.definition_name
    definition = Definition.find_by(name: args.definition_name)

    CoreLogicLocation.includes(:video).find_each do |cl|
      begin
        VideoGenerator.new(cl, definition).generate
      rescue => e
        Honeybadger.notify(e, context: {core_logic_location_zip_code: cl.zip_code, core_logic_location_period_date: cl.period_date})
      end
    end
  end
end
