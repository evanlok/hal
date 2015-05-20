class Definition < ActiveRecord::Base
  # Validations
  validates :name, :class_name, presence: true
  validates :name, :class_name, uniqueness: true
end
