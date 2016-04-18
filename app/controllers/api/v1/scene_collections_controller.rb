class Api::V1::SceneCollectionsController < Api::V1::BaseController
  def show
    @scene_collection = SceneCollection.find(params[:id])
    render json: scene_collection_json(@scene_collection)
  end

  def create
    @scene_collection = SceneCollection.new(data: scene_collection_params)

    if @scene_collection.save && @scene_collection.generate
      render json: scene_collection_json(@scene_collection), status: :created
    else
      render json: { errors: @scene_collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @scene_collection = SceneCollection.find(params[:id])

    if @scene_collection.update(data: scene_collection_params) && @scene_collection.generate
      render json: scene_collection_json(@scene_collection)
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

  def scene_collection_json(scene_collection)
    scene_collection.data.merge(id: scene_collection.id)
  end
end
