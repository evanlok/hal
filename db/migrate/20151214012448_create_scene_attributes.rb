class CreateSceneAttributes < ActiveRecord::Migration
  def up
    create_table :scene_attributes do |t|
      t.belongs_to :scene
      t.belongs_to :scene_attribute_type, index: true
      t.string :name
      t.string :display_name

      t.timestamps null: false
    end

    add_index :scene_attributes, [:scene_id, :name], unique: true
  end

  def down
    drop_table :scene_attributes
  end
end
