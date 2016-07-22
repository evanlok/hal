class SceneAttributeType < ActiveRecord::Base
  # Associations
  has_many :scene_attributes, dependent: :restrict_with_exception
  has_many :global_scene_attributes, dependent: :restrict_with_exception

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: true
end
