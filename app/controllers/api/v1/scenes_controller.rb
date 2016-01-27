module Api::V1
  class ScenesController < BaseController
    def index
      params[:limit] = 1000 if params[:limit].to_i > 1000
      @scenes = Scene.includes(scene_attributes: :scene_attribute_type).page(params[:page]).per(params[:limit])
    end

    def show
      @scene = Scene.includes(scene_attributes: :scene_attribute_type).find(params[:id])
    end
  end
end
