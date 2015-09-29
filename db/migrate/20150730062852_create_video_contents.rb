class CreateVideoContents < ActiveRecord::Migration
  def up
    create_table :video_contents do |t|
      t.string :uid
      t.json :data
      t.integer :definition_id
      t.timestamps null: false
    end

    add_index :video_contents, :uid
    add_index :video_contents, :definition_id
  end

  def down
    drop_table :video_contents
  end
end
