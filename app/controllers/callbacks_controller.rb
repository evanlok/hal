class CallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_video, only: [:encoder, :stream]

  # Triggered by video generations
  def encoder
    status = params[:status]
    video_url = params[:outputs].find { |o| o[:label] == 'medium' }.dig(:url)
    thumbnail_url = params[:outputs].find { |o| o[:label] == 'high' }.dig(:thumbnail, :url)

    if video_url && status == 'finished'
      filename, ext = File.basename(video_url).split('.')
      unversioned_name = [filename.gsub(/_\d+\z/, ''), ext].join('.')
      duration = params[:input][:duration_in_ms].to_i / 1000
      @video.update_attributes(filename: unversioned_name, duration: duration, thumbnail_url: thumbnail_url)
      Notifiers::VideoCallbackNotifier.notify(@video)
    end

    js false
    render json: { id: @video.id }
  end

  # Triggered by video generations
  def stream
    stream_url = params[:stream][:url]
    js false

    if @video.update(stream_url: stream_url)
      Notifiers::StreamCallbackNotifier.notify(@video)

      render json: { id: @video.id }
    else
      render json: { errors: @video.errors.full_messages }, status: :bad_request
    end
  end

  # Triggered by video previews
  def preview
    @video_preview = VideoPreview.find(params[:video_id])
    js false

    if @video_preview.update(stream_url: params[:stream][:url])
      Notifiers::PreviewCallbackNotifier.notify(@video_preview)

      render json: { id: @video_preview.id }
    else
      render json: { errors: @video_preview.errors.full_messages }, status: :bad_request
    end
  end

  protected

  def load_video
    @video = Video.find(params[:video_id])
  end
end
