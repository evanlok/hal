class SceneAttribute < ActiveRecord::Base
  # Associations
  belongs_to :scene_attribute_type
  belongs_to :scene, touch: true

  # Validations
  validates :scene_attribute_type, :scene, :name, :display_name, presence: true
  validates :name, format: { with: /\A[a-z_\d]+\z/, message: 'only allows lowercase letters, underscores, and numbers' }
  validates :name, uniqueness: { scope: :scene_id }
end
