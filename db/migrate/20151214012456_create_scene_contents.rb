class CreateSceneContents < ActiveRecord::Migration
  def up
    create_table :scene_contents do |t|
      t.belongs_to :scene
      t.belongs_to :scene_collection
      t.json :data
      t.string :transition
      t.float :transition_duration, default: 0

      t.timestamps null: false
    end

    add_index :scene_contents, [:scene_collection_id, :scene_id], unique: true
  end

  def down
    drop_table :scene_contents
  end
end
