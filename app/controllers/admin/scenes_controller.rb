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
    @versions = @scene.versions.pluck(:created_at, :id).reverse.map { |date, id| [date.to_s(:full), id] }

    if params[:version_id].present?
      @scene = @scene.versions.find(params[:version_id]).reify
    end
  end

  def update
    if @scene.update(scene_params)
      redirect_to [:edit, :admin, @scene], notice: "Updated scene: #{@scene.name}"
    else
      js :edit
      render :edit
    end
  end

  def destroy
    @scene.destroy
    redirect_to admin_scenes_url, notice: "Deleted scene: #{@scene.name}"
  end

  def preview
    @scene = Scene.find(params[:scene_id]) if params[:scene_id].present?
    scene_data = params[:scene_data].present? ? JSON.parse(params[:scene_data]) : {}
    scene_preview_video = Engine::Definitions::ScenePreviewVideo.new(params[:scene_vgl], scene_data)
    errors = []

    begin
      vgl = scene_preview_video.to_vgl
    rescue => e
      errors << e.message
    end

    if errors.blank?
      video_preview = VideoPreviewer.new(vgl, @scene).create_video_preview
      render json: { id: video_preview.id }
    else
      render json: { errors: errors }, status: :bad_request
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