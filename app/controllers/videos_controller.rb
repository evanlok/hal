class VideosController < ApplicationController
  layout 'embed'

  before_action :load_video

  def show
    js_params = {
      video_id: @video.id,
      video_type: @video.videoable.definition.video_type.name,
      definition: @video.videoable.definition.name,
      video_uid: @video.videoable.uid
    }

    js js_params
  end

  def stream
    respond_to do |format|
      format.json do
        render json: {stream_url: @video.stream_url}
      end
    end
  end

  protected

  def load_video
    @video = Video.find(params[:id])
  end
end
