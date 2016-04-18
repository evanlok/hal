module Previewable
  extend ActiveSupport::Concern

  included do
    has_many :video_previews, as: :previewable, dependent: :delete_all
  end
end
