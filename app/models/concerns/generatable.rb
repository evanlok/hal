module Generatable
  extend ActiveSupport::Concern

  included do
    has_many :videos, as: :videoable, dependent: :destroy
  end

  def video
    if videos.loaded?
      videos.sort_by(&:id).reject { |v| v.filename.blank? }.last
    else
      videos.where.not(filename: nil).order(:id).last
    end
  end

  def generate(*args)
    definition = DefinitionFactory.fetch(self)
    video_generator = VideoGenerator.new(definition)
    video = video_generator.generate(*args)

    if video_generator.errors.present?
      video_generator.errors.each { |error| errors.add(:base, error) }
      false
    else
      video
    end
  end
end
