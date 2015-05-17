class Video < ActiveRecord::Base
  # Associations
  belongs_to :videoable, polymorphic: true

  # Validations
  validates :videoable, presence: true
end
