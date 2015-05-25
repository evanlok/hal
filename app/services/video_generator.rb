class VideoGenerator
  attr_reader :videoable, :definition

  def initialize(videoable, definition)
    @videoable = videoable
    @definition = definition
  end

  def generate(priority = 'medium')
    video = fetch_video
    VidgenieClient.post_video(video, priority)
  end

  def fetch_video
    video = videoable.video || videoable.build_video
    video.definition = definition
    video.save
    video
  end
end
