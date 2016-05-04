class AddDataToSceneCollections < ActiveRecord::Migration
  def change
    add_column :scene_collections, :data, :jsonb
  end
end
