class AddCallbackUrlToVideoContents < ActiveRecord::Migration
  def change
    add_column :video_contents, :callback_url, :text
  end
end
