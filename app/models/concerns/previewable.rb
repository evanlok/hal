module Previewable
  extend ActiveSupport::Concern

  included do
    has_many :video_previews, as: :previewable, dependent: :delete_all
  end

  def preview(definition: nil, callback_url: nil)
    definition ||= DefinitionFactory.fetch(self)
    video_previewer = VideoPreviewer.new(definition)
    video_preview = video_previewer.create_video_preview(reference: self, callback_url: callback_url)

    if video_previewer.errors.present?
      video_previewer.errors.each { |error| errors.add(:base, error) }
      false
    else
      video_preview
    end
  end
end
