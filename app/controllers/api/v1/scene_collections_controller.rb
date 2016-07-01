class Api::V1::SceneCollectionsController < Api::V1::BaseController
  before_action :load_scene_collection, except: :create

  def show
    render json: scene_collection_json(@scene_collection)
  end

  def create
    @scene_collection = SceneCollection.new(data: scene_collection_params)

    if @scene_collection.save
      render json: scene_collection_json(@scene_collection), status: :created
    else
      render json: { errors: @scene_collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @scene_collection.update(data: scene_collection_params)
      render json: scene_collection_json(@scene_collection)
    else
      render json: { errors: @scene_collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @scene_collection.destroy
    render json: { id: @scene_collection.id }
  end

  def generate
    if @scene_collection.generate(callback_url: params[:callback_url], stream_callback_url: params[:stream_callback_url])
      render json: { id: @scene_collection.id, generate: true, callback_url: params[:callback_url], stream_callback_url: params[:stream_callback_url] }
    else
      render json: { errors: @scene_collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def preview
    if @scene_collection.preview(callback_url: params[:callback_url])
      render json: { id: @scene_collection.id, preview: true, callback_url: params[:callback_url] }
    else
      render json: { errors: @scene_collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def load_scene_collection
    @scene_collection = SceneCollection.find(params[:id])
  end

  def scene_collection_params
    params.permit(:font, :music, :color, :callback_url, :user_audio, scenes: [:scene_id, :transition, :transition_duration]).tap do |whitelisted|
      whitelisted[:scenes].each_with_index do |scene, idx|
        scene[:data] = params[:scenes][idx][:data]
      end
    end
  end

  def scene_collection_json(scene_collection)
    scene_collection.data.merge(id: scene_collection.id)
  end
end
