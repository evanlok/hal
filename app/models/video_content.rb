class VideoContent < ActiveRecord::Base
  # Associations
  belongs_to :definition
  has_one :video, as: :videoable, dependent: :destroy

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
