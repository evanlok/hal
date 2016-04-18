module Previewable
  extend ActiveSupport::Concern

  included do
    has_many :video_previews, as: :previewable, dependent: :delete_all
  end

  def preview
    definition = DefinitionFactory.fetch(self)
    video_previewer = VideoPreviewer.new(definition, self)
    video_preview = video_previewer.create_video_preview

    if video_previewer.errors.present?
      video_previewer.errors.each { |error| errors.add(:base, error) }
      false
    else
      video_preview
    end
  end
end
