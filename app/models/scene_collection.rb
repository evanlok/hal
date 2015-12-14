class SceneCollection < ActiveRecord::Base
  # Associations
  has_many :scene_contents, dependent: :destroy
  has_many :scenes, through: :scene_contents
end
