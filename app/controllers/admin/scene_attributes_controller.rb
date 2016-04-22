class Admin::SceneAttributesController < Admin::BaseController
  before_action :load_scene
  before_action :load_scene_attribute, only: [:edit, :update, :destroy]

  def index
    @scene_attributes = @scene.scene_attributes.includes(:scene_attribute_type).order(:name).page(params[:page])
  end

  def new
    @scene_attribute = @scene.scene_attributes.build
  end

  def create
    @scene_attribute = @scene.scene_attributes.build(scene_attribute_params)

    if @scene_attribute.save
      redirect_to [:admin, @scene, SceneAttribute], notice: "Created scene attribute: #{@scene_attribute.name}"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @scene_attribute.update(scene_attribute_params)
      respond_to do |format|
        format.html { redirect_to [:admin, @scene, SceneAttribute], notice: "Updated scene attribute: #{@scene_attribute.name}" }
        format.json { render json: @scene_attribute }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @scene_attribute.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @scene_attribute.destroy
    redirect_to [:admin, @scene, SceneAttribute], notice: "Deleted scene attribute: #{@scene_attribute.name}"
  end

  protected

  def load_scene
    @scene = Scene.find(params[:scene_id])
  end

  def load_scene_attribute
    @scene_attribute = SceneAttribute.find(params[:id])
  end

  def scene_attribute_params
    params.require(:scene_attribute).permit!
  end
end
