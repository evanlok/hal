class FindTheBestLocation < ActiveRecord::Base
  include Generatable

  extend FriendlyId
  friendly_id :county, use: [:slugged, :history, :finders]

  DEFINITION_NAME = 'FindTheHome'.freeze

  # Associations
  belongs_to :definition

  # Validations
  validates :ftb_id, :county, :definition, presence: true
  validates :ftb_id, uniqueness: true

  # Callbacks
  before_validation :set_definition, on: :create

  def should_generate_new_friendly_id?
    county_changed? || super
  end

  def video_data
    @video_data ||= Hashie::Mash.new(attributes)
  end

  def uid
    county.strip
  end

  private

  def set_definition
    self.definition ||= Definition.find_by(name: DEFINITION_NAME)
  end
end
