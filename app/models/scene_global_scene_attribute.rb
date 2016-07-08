class SceneGlobalSceneAttribute < ActiveRecord::Base
  # Associations
  belongs_to :global_scene_attribute
  belongs_to :scene
end
