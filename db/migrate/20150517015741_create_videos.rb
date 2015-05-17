class CreateVideos < ActiveRecord::Migration
  def up
    create_table :videos do |t|
      t.belongs_to :videoable, polymorphic: true
      t.string :url
      t.integer :duration
      t.string :thumbnail_url

      t.timestamps null: false
    end

    add_index :videos, [:videoable_id, :videoable_type]
  end

  def down
    drop_table :videos
  end
end
