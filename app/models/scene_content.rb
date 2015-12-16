class SceneContent < ActiveRecord::Base
  acts_as_list scope: [:scene_collection_id, :scene_id]

  # Associations
  belongs_to :scene
  belongs_to :scene_collection

  # Validations
  validates :scene, :scene_collection, :data, presence: true
  validates :scene_collection_id, uniqueness: { scope: :scene_id }

  # Scopes
  scope :by_position, -> { order(:position) }

  def scene_data
    @scene_data ||= Hashie::Mash.new(data)
  end
end
