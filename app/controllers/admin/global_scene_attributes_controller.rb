class Admin::GlobalSceneAttributesController < Admin::BaseController
  before_action :load_global_scene_attribute, only: [:edit, :update, :destroy]

  def index
    @global_scene_attributes = GlobalSceneAttribute.page(params[:page])
  end

  def new
    @global_scene_attribute = GlobalSceneAttribute.new
  end

  def create
    @global_scene_attribute = GlobalSceneAttribute.new(global_scene_attribute_params)

    if @global_scene_attribute.save
      redirect_to admin_global_scene_attributes_url, notice: "Created global scene attribute: #{@global_scene_attribute.name}"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @global_scene_attribute.update(global_scene_attribute_params)
      redirect_to admin_global_scene_attributes_url, notice: "Updated global scene attribute: #{@global_scene_attribute.name}"
    else
      render :edit
    end
  end

  def destroy
    @global_scene_attribute.destroy
    redirect_to admin_global_scene_attributes_url, notice: "Deleted global scene attribute: #{@global_scene_attribute.name}"
  end

  private

  def load_global_scene_attribute
    @global_scene_attribute = GlobalSceneAttribute.find(params[:id])
  end

  def global_scene_attribute_params
    params.require(:global_scene_attribute).permit!
  end
end
