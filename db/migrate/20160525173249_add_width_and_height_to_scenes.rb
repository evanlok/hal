class AddWidthAndHeightToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :width, :integer
    add_column :scenes, :height, :integer

    Scene.update_all(width: 1280, height: 720)
  end
end
