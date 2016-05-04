class SceneCollection < ActiveRecord::Base
  include Previewable
  include Generatable

  def data=(val)
    @video_data = nil
    super
  end

  def scenes
    if data['scenes'].present?
      scene_ids = data['scenes'].map { |scene_data| scene_data['scene_id'].to_i }
      scenes_by_id = Scene.where(id: scene_ids).index_by(&:id)
      scene_ids.map { |scene_id| scenes_by_id[scene_id] }
    else
      []
    end
  end

  def callback_url
    video_data.callback_url
  end

  def video_data
    @video_data ||= Hashie::Mash.new(data)
  end
end
