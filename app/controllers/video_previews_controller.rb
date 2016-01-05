class VideoPreviewsController < ApplicationController
  layout 'embed'

  def show
    @video_preview = VideoPreview.find(params[:id])

    respond_to do |format|
      format.html do
        js id: @video_preview.id
      end

      format.json do
        render json: { stream_url: @video_preview.stream_url }
      end
    end
  end
end
