namespace :videos do
  desc 'Generate all videos for a definition'
  task :generate_all, [:definition] => :environment do |t, args|
    definition = Definition.find_by!(class_name: args.definition)

    definition.video_contents.find_each do |video_content|
      VideoGenerator.new(video_content).generate
    end
  end
end
