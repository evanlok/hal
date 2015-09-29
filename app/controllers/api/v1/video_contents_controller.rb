module Api::V1
  class VideoContentsController < BaseController
    def create
      @video_content = VideoContent.new(video_content_params)

      begin
        video_type = VideoType.find_by!(name: params[:video_type])
        definition = video_type.definitions.find_by!(class_name: params[:definition])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :bad_request
      end

      @video_content.definition = definition

      if @video_content.save
        VideoGenerator.new(@video_content).generate
        render status: :created
      else
        render json: { errors: @video_content.errors.full_messages }, status: :bad_request
      end
    end

    private

    def video_content_params
      params.permit(:data, :uid, :callback_url)
    end
  end
end
