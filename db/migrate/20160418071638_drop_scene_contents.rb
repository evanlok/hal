class DropSceneContents < ActiveRecord::Migration
  def change
    drop_table :scene_contents
  end
end
