class GlobalSceneAttribute < ActiveRecord::Base
  # Associations
  belongs_to :scene_attribute_type
  has_many :scene_global_scene_attributes, dependent: :destroy
  has_many :scenes, through: :scene_global_scene_attributes

  # Validations
  validates :name, :display_name, :scene_attribute_type_id, presence: true
end
