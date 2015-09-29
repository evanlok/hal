class VideoType < ActiveRecord::Base
  # Associations
  has_many :definitions

  # Validations
  validates :name, presence: true
  validates :name, class_name: true
end
