class VideosController < ApplicationController
  def show
    @video = Video.find(params[:id])
    render layout: 'embed'
  end
end
