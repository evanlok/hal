class Admin::SceneCollectionsController < Admin::BaseController
  before_action :load_scene_collection, only: [:edit, :update, :destroy]

  def index
    @scene_collections = SceneCollection.includes(scene_contents: :scene).order(id: :desc).page(params[:page])
  end

  def new
    @scene_collection = SceneCollection.new
  end

  def create
    @scene_collection = SceneCollection.new(scene_collection_params)

    if @scene_collection.save
      redirect_to [:edit, :admin, @scene_collection], notice: "Created scene collection: #{@scene_collection.id}"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @scene_collection.update(scene_collection_params)
      redirect_to [:edit, :admin, @scene_collection], notice: "Updated scene collection: #{@scene_collection.id}"
    else
      render :edit
    end
  end

  def destroy
    @scene_collection.destroy
    redirect_to admin_scene_collections_url, notice: "Deleted scene collection: #{@scene_collection.id}"
  end

  protected

  def load_scene_collection
    @scene_collection = SceneCollection.find(params[:id])
  end

  def scene_collection_params
    params.require(:scene_collection).permit!
  end
end
