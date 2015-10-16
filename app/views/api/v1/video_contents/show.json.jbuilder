json.partial! 'video_content', video_content: @video_content
json.extract! @video_content.video, :duration, :thumbnail_url, :stream_url
json.video_url_360 @video_content.video.url
json.video_url_720 @video_content.video.url(720)
json.embed_url video_url(@video_content.video)
