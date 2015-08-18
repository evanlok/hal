class CallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_video

  def encoder
    status = params[:status]
    video_url = params['outputs'].find {|o| o['label'] == 'medium' }.try(:[], 'url')

    if video_url && status == 'finished'
      filename = File.basename(video_url)
      duration = params['input']['duration_in_ms'].to_i
      @video.update_attributes(filename: filename, duration: duration)
    end

    js false
    render json: {id: @video.id}
  end

  def stream
    stream_url = params[:stream][:url]
    js false

    if @video.update(stream_url: stream_url)
      render json: { id: @video.id }
    else
      render json: { errors: @video.errors.full_messages }, status: :bad_request
    end
  end

  protected

  def load_video
    @video = Video.find(params[:video_id])
  end
end
