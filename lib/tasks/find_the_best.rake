namespace :find_the_best do
  desc 'Generate all videos for FindTheBestLocation records'
  task generate_all: :environment do
    FindTheBestLocation.includes(:video).find_each do |ftb|
      begin
        VideoGenerator.new(ftb).generate
      rescue => e
        Honeybadger.notify(e, context: {find_the_best_location_id: ftb.id})
      end
    end
  end
end
