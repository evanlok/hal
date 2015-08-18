class CoreLogicLocation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :zip_code, use: [:slugged, :history, :finders]

  DEFINITION_NAME = 'CoreLogic'.freeze
  
  # Associations
  belongs_to :definition
  has_one :video, as: :videoable, dependent: :destroy

  # Validation
  validates :zip_code, :period_date, :definition, presence: true
  validates :active_list_price_mean, uniqueness: true

  # Callbacks
  before_validation :set_definition, on: :create

  def video_data
    @video_data ||= Hashie::Mash.new(attributes)
  end

  private
  def set_definition
    self.definition ||= Definition.find_by(name: DEFINITION_NAME)
  end
end
