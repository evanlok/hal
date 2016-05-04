class AddCallbackUrlToVideosAndPreview < ActiveRecord::Migration
  def change
    add_column :videos, :callback_url, :text
    add_column :videos, :stream_callback_url, :text
    add_column :video_previews, :callback_url, :text
  end
end
