class Api::V1::SceneCollectionsController < Api::V1::BaseController
  def show
    @scene_collection = SceneCollection.find(params[:id])
  end

  def create
    @scene_collection = SceneCollection.new(data: scene_collection_params)

    if @scene_collection.save
      render :show, status: :created
    else
      render json: { errors: @scene_collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @scene_collection = SceneCollection.find(params[:id])

    if @scene_collection.update(data: scene_collection_params)
      render :show
    else
      render json: { errors: @scene_collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def scene_collection_params
    params.permit(:font, :music, :color, :callback_url, scenes: [:scene_id, :transition, :transition_duration]).tap do |whitelisted|
      whitelisted[:scenes].each_with_index do |scene, idx|
        scene[:data] = params[:scenes][idx][:data]
      end
    end
  end
end
