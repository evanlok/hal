class SceneCollection < ActiveRecord::Base
  # Associations
  has_many :scene_contents, -> { order(:position) }, dependent: :destroy
  has_many :scenes, through: :scene_contents
  has_one :video, as: :videoable, dependent: :destroy
  has_many :video_previews, as: :previewable, dependent: :delete_all
end
