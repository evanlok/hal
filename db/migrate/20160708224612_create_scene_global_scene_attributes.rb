class CreateSceneGlobalSceneAttributes < ActiveRecord::Migration
  def change
    create_table :scene_global_scene_attributes do |t|
      t.belongs_to :scene
      t.belongs_to :global_scene_attribute

      t.timestamps null: false
    end

    add_index :scene_global_scene_attributes, [:scene_id, :global_scene_attribute_id], unique: true, name: 'scene_id_global_scene_attribute_id_index'
    add_index :scene_global_scene_attributes, :global_scene_attribute_id, name: 'global_scene_attribute_id_index'
  end
end
