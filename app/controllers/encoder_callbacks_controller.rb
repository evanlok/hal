class EncoderCallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    status = params['status']
    video_url = params['outputs'].find {|o| o['label'] == 'medium' }.try(:[], 'url')
    video = Video.find(params['reference_id'])

    if video_url && status == 'finished'
      filename = File.basename(video_url)
      duration = params['input']['duration_in_ms'].to_i
      video.update_attributes(filename: filename, duration: duration)
    end

    js false
    render json: {id: video.id}
  end
end
