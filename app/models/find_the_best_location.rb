class FindTheBestLocation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :county, use: [:slugged, :history, :finders]

  # Associations
  has_one :video, as: :videoable, dependent: :destroy

  # Validations
  validates :ftb_id, :county, presence: true
  validates :ftb_id, uniqueness: true

  def should_generate_new_friendly_id?
    county_changed? || super
  end
end
