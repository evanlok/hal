class SceneContent < ActiveRecord::Base
  # Associations
  belongs_to :scene
  belongs_to :scene_collection

  # Validations
  validates :scene, :scene_collection, :data, presence: true
  validates :scene_collection_id, uniqueness: { scope: :scene_id }

  def scene_data
    @scene_data ||= Hashie::Mash.new(data)
  end
end
