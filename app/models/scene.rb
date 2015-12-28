class Scene < ActiveRecord::Base
  has_paper_trail

  # Associations
  has_many :scene_attributes, dependent: :destroy
  has_many :scene_contents, dependent: :restrict_with_exception

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: true
end
