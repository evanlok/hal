class AddDescriptionToSceneAttributes < ActiveRecord::Migration
  def change
    add_column :scene_attributes, :description, :text
  end
end
