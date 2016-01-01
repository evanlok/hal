class Scene < ActiveRecord::Base
  has_paper_trail

  # Associations
  has_many :scene_attributes, dependent: :destroy
  has_many :scene_contents, dependent: :restrict_with_exception
  has_many :video_previews, as: :previewable, dependent: :delete_all

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: true
end
