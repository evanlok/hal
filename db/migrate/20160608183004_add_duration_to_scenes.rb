class AddDurationToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :duration, :integer
    Scene.update_all(duration: 0)
  end
end
