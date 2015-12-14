class Scene < ActiveRecord::Base
  # Associations
  has_many :scene_attributes, dependent: :destroy
  has_many :scene_contents, dependent: :restrict_with_exception

  # Validations
  validates :name, presence: true
end
