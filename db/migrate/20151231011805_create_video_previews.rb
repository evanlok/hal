class CreateVideoPreviews < ActiveRecord::Migration
  def up
    create_table :video_previews do |t|
      t.belongs_to :previewable, polymorphic: true
      t.text :stream_url

      t.timestamps null: false
    end

    add_index :video_previews, [:previewable_id, :previewable_type]
  end

  def down
    drop_table :video_previews
  end
end
