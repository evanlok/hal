module VideosHelper
  def video_poster_url(video)
    'https://vejeo.s3.amazonaws.com/videos/video-preroll-image.jpg' unless video.url
  end
end
