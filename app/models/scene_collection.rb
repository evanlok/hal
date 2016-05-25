class SceneCollection < ActiveRecord::Base
  include Previewable
  include Generatable

  validate :scenes_have_same_dimensions?

  def data=(val)
    @video_data = nil
    @scenes = nil
    super
  end

  def scenes
    @scenes ||= begin
      if data['scenes'].present?
        scene_ids = data['scenes'].map { |scene_data| scene_data['scene_id'].to_i }
        scenes_by_id = Scene.where(id: scene_ids).index_by(&:id)
        scene_ids.map { |scene_id| scenes_by_id[scene_id] }
      else
        []
      end
    end
  end

  def callback_url
    video_data.callback_url
  end

  def video_data
    @video_data ||= Hashie::Mash.new(data)
  end

  def width
    scenes.first&.width
  end

  def height
    scenes.first&.height
  end

  private

  def scenes_have_same_dimensions?
    return if scenes.empty?
    first_scene = scenes.first

    valid = scenes.all? do |scene|
      scene.width == first_scene.width && scene.height == first_scene.height
    end

    errors.add(:data, 'scenes contain different resolutions') unless valid
  end
end
