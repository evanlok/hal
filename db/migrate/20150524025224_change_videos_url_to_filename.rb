class ChangeVideosUrlToFilename < ActiveRecord::Migration
  def change
    rename_column :videos, :url, :filename
  end
end
