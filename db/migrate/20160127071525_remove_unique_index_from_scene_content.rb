class RemoveUniqueIndexFromSceneContent < ActiveRecord::Migration
  def up
    remove_index :scene_contents, [:scene_collection_id, :scene_id]
    add_index :scene_contents, [:scene_collection_id, :scene_id]
  end

  def down
    remove_index :scene_contents, [:scene_collection_id, :scene_id]
    add_index :scene_contents, [:scene_collection_id, :scene_id], unique: true
  end
end
