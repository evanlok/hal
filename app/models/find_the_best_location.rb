class FindTheBestLocation < ActiveRecord::Base
  # Associations
  has_one :video, as: :videoable

  # Validations
  validates :ftb_id, :county, presence: true
end
