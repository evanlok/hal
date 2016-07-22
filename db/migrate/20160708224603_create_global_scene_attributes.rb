class CreateGlobalSceneAttributes < ActiveRecord::Migration
  def change
    create_table :global_scene_attributes do |t|
      t.string :name
      t.string :display_name
      t.text :description
      t.belongs_to :scene_attribute_type

      t.timestamps null: false
    end
  end
end
