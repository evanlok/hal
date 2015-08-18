class VideoGenerator
  attr_reader :video_content

  def initialize(video_content)
    @video_content = video_content
  end

  def generate(priority = 'normal', stream_only: false)
    video = fetch_video
    vgl_generator = VGLGenerator.new(video_content)
    encoder = OnvedeoVideoEncoder.new(video)
    vidgenie_client = VidgenieClient.new(vgl_generator, encoder, priority, { type: video.videoable_type, id: video.videoable_id, video_id: video.id })
    vidgenie_client.post_to_server(stream_only: stream_only)
  end

  def fetch_video
    video = video_content.video || video_content.build_video
    video.save
    video
  end
end
