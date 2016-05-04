class AddPositionToSceneAttributes < ActiveRecord::Migration
  def change
    add_column :scene_attributes, :position, :integer
  end
end
