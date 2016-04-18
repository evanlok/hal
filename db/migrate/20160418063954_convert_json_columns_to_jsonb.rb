class ConvertJsonColumnsToJsonb < ActiveRecord::Migration
  def change
    change_column :video_contents, :data, :jsonb
    change_column :scene_contents, :data, :jsonb
    change_column :video_types, :schema, :jsonb
    change_column :versions, :object, :jsonb
  end
end
