class RemoveColumnsFromSceneCollections < ActiveRecord::Migration
  def change
    remove_column :scene_collections, :font
    remove_column :scene_collections, :music
    remove_column :scene_collections, :color
    remove_column :scene_collections, :callback_url
  end
end
