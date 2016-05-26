class Admin::ScenesController < Admin::BaseController
  before_action :load_scene, only: [:edit, :update, :destroy]

  def index
    @scenes = Scene.order(:name).page(params[:page])
  end

  def new
    @scene = Scene.new
    js :edit
  end

  def create
    @scene = Scene.new(scene_params)

    if @scene.save
      redirect_to [:edit, :admin, @scene], notice: "Created scene: #{@scene.name}"
    else
      js :edit
      render :new
    end
  end

  def edit
    if params[:version_id].present?
      @scene = @scene.versions.find(params[:version_id]).reify
    end

    js scene_id: @scene.id
  end

  def update
    if @scene.update(scene_params)
      redirect_to [:edit, :admin, @scene], notice: "Updated scene: #{@scene.name}"
    else
      js :edit, scene_id: @scene.id
      render :edit
    end
  end

  def destroy
    @scene.destroy
    redirect_to admin_scenes_url, notice: "Deleted scene: #{@scene.name}"
  end

  def preview
    if params[:scene_id].present?
      @scene = Scene.find(params[:scene_id])
    else
      @scene = Scene.new
    end

    scene_data = params[:scene_data].present? ? JSON.parse(params[:scene_data]) : {}
    scene_preview_video = Engine::Definitions::ScenePreviewVideo.new(params[:scene_vgl], scene_data, width: params[:width], height: params[:height])
    video_preview = @scene.preview(definition: scene_preview_video)

    if video_preview
      render json: { id: video_preview.id }
    else
      render json: { errors: @scene.errors.full_messages }, status: :bad_request
    end
  end

  protected

  def load_scene
    @scene = Scene.find(params[:id])
  end

  def scene_params
    params.require(:scene).permit!
  end
end
