class Admin::SceneContentsController < Admin::BaseController
  before_action :load_scene_collection
  before_action :load_scene_content, only: [:edit, :update, :destroy]

  def index
    @scene_contents = @scene_collection.scene_contents.includes(:scene).page(params[:page])
  end

  def new
    @scene_content = @scene_collection.scene_contents.build
  end

  def create
    @scene_content = @scene_collection.scene_contents.build(scene_content_params)

    if @scene_content.save
      redirect_to [:edit, :admin, @scene_collection, @scene_content], notice: "Created scene content: #{@scene_content.id}"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @scene_content.update(scene_content_params)
      redirect_to [:edit, :admin, @scene_collection, @scene_content], notice: "Updated scene content: #{@scene_content.id}"
    else
      render :edit
    end
  end

  def destroy
    @scene_content.destroy
    redirect_to [:admin, @scene_collection, SceneContent], notice: "Deleted scene content: #{@scene_content.id}"
  end

  protected

  def load_scene_collection
    @scene_collection = SceneCollection.find(params[:scene_collection_id])
  end

  def load_scene_content
    @scene_content = SceneContent.find(params[:id])
  end

  def scene_content_params
    params.require(:scene_content).permit!
  end
end
