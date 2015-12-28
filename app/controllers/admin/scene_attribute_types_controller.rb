class Admin::SceneAttributeTypesController < Admin::BaseController
  before_action :load_scene_attribute_type, only: [:edit, :update, :destroy]

  def index
    @scene_attribute_types = SceneAttributeType.order(:name).page(params[:page])
  end

  def new
    @scene_attribute_type = SceneAttributeType.new
  end

  def create
    @scene_attribute_type = SceneAttributeType.new(scene_attribute_type_params)

    if @scene_attribute_type.save
      redirect_to admin_scene_attribute_types_url, notice: "Created scene attribute type: #{@scene_attribute_type.name}"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @scene_attribute_type.update(scene_attribute_type_params)
      redirect_to admin_scene_attribute_types_url, notice: "Updated scene attribute type: #{@scene_attribute_type.name}"
    else
      render :edit
    end
  end

  def destroy
    @scene_attribute_type.destroy
    redirect_to admin_scene_attribute_types_url, notice: "Deleted scene attribute type: #{@scene_attribute_type.name}"
  end

  protected

  def load_scene_attribute_type
    @scene_attribute_type = SceneAttributeType.find(params[:id])
  end

  def scene_attribute_type_params
    params.require(:scene_attribute_type).permit!
  end
end
