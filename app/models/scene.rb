class Scene < ActiveRecord::Base
  include Previewable

  has_paper_trail

  # Associations
  has_many :scene_attributes, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: true

  # Scopes
  scope :active, -> { where(active: true) }
end
