class VideoPreview < ActiveRecord::Base
  # Associations
  belongs_to :previewable, polymorphic: true
end
