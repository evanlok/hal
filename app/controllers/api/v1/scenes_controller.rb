module Api::V1
  class ScenesController < BaseController
    def index
      params[:limit] = 1000 if params[:limit].to_i > 1000
      updated_at_start_time = Time.at(params[:since].to_i) if params[:since].present?
      @scenes = Scene.active.includes(scene_attributes: :scene_attribute_type).page(params[:page]).per(params[:limit])
      @scenes = @scenes.where('updated_at >= ?', updated_at_start_time) if updated_at_start_time
    end

    def show
      @scene = Scene.includes(scene_attributes: :scene_attribute_type).find(params[:id])
    end
  end
end
