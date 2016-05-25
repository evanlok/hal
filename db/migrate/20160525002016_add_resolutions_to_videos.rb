class AddResolutionsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :resolutions, :jsonb
  end
end
