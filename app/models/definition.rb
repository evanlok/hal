class Definition < ActiveRecord::Base
  # Validations
  validates :name, :class_name, presence: true
  validates :name, :class_name, uniqueness: true
  validates :class_name, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
end
