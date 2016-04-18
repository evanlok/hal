class VideoContent < ActiveRecord::Base
  include Previewable
  include Generatable

  # Associations
  belongs_to :definition
  has_many :videos, as: :videoable, dependent: :destroy

  # Validations
  validates :data, :definition, presence: true
  validates :uid, uniqueness: { scope: :definition_id }, allow_blank: true

  def video_data
    @video_data ||= Hashie::Mash.new(data)
  end

  def data=(val)
    @video_data = nil
    super
  end
end
