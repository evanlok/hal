class ConvertJsonColumnsToJsonb < ActiveRecord::Migration
  def change
    execute 'ALTER TABLE video_contents ALTER COLUMN data SET DATA TYPE jsonb USING data::jsonb;'
    execute 'ALTER TABLE scene_contents ALTER COLUMN data SET DATA TYPE jsonb USING data::jsonb;'
    execute 'ALTER TABLE video_types ALTER COLUMN schema SET DATA TYPE jsonb USING schema::jsonb;'
    execute 'ALTER TABLE versions ALTER COLUMN object SET DATA TYPE jsonb USING object::jsonb;'
  end
end
