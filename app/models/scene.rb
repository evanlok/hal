class Scene < ActiveRecord::Base
  include Previewable

  has_paper_trail

  # Associations
  has_many :scene_attributes, -> { order(:position) }, dependent: :destroy

  # Validations
  validates :name, :width, :height, :duration, presence: true
  validates :name, uniqueness: true
  validates :width, :height, numericality: { greater_than: 0 }

  # Scopes
  scope :active, -> { where(active: true) }
end
