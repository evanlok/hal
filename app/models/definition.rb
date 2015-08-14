class Definition < ActiveRecord::Base
  # Associations
  belongs_to :video_type
  has_many :video_contents, dependent: :nullify
  has_many :find_the_best_locations, dependent: :nullify
  has_many :core_logic_locations, dependent: :nullify

  # Validations
  validates :name, :class_name, :video_type, presence: true
  validates :name, :class_name, uniqueness: { scope: :video_type_id }
  validates :class_name, class_name: true
end
