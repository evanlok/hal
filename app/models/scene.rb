class Scene < ActiveRecord::Base
  include Previewable

  has_paper_trail

  # Associations
  has_many :scene_attributes, -> { order(:position) }, dependent: :destroy
  has_many :scene_global_scene_attributes, dependent: :destroy
  has_many :global_scene_attributes, through: :scene_global_scene_attributes

  # Validations
  validates :name, :width, :height, :duration, presence: true
  validates :name, uniqueness: true
  validates :width, :height, numericality: { greater_than: 0 }

  # Scopes
  scope :active, -> { where(active: true) }
end
