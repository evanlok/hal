class AddResolutionsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :resolutions, :jsonb

    vr = VideoResolutions.new(1280, 720)
    Video.where(resolutions: nil).update_all resolutions: vr.json
  end
end
